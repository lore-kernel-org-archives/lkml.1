Return-Path: <linux-kernel-owner+w=401wt.eu-S1760074AbYFXO1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074AbYFXO1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbYFXO1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:27:35 -0400
Received: from smtp-out.google.com ([216.239.33.17]:40304 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbYFXO1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:27:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=fClyc15AOQTxVK8/wBInhaJrxHTiOOlcwmdnvYriShKpauluILlX9ryJdgb8M5Iye
	E7g8Tf8lA93Yo8nHSjm/w==
Message-ID: <6599ad830806240727w401a8511p27dd90843378f35d@mail.gmail.com>
Date: Tue, 24 Jun 2008 07:27:14 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com, menage@google.com, pj@sgi.com, xemul@openvz.org,
       serue@us.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 2/8] CGroup Files: Add write_string cgroup control file method
In-Reply-To: <20080622143236.GA19380@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080620234358.182933000@menage.corp.google.com>
	 <20080621000730.052131000@menage.corp.google.com>
	 <20080622143236.GA19380@balbir.in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 7:32 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> +static ssize_t cgroup_write_string(struct cgroup *cgrp, struct cftype *cft,
>> +                                struct file *file,
>> +                                const char __user *userbuf,
>> +                                size_t nbytes, loff_t *unused_ppos)
>> +{
>> +     char local_buffer[64];
>
> 64? a define  would be more meaningful

Potentially, although it would be unlikely to be reused anywhere else.
It's just meant to be a size that's big enough for any numerical
value, and for the vast majority of other writes.

Paul
