Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbZFBQIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbZFBQIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 12:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbZFBQII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 12:08:08 -0400
Received: from smtp-out.google.com ([216.239.45.13]:63161 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbZFBQIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 12:08:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Du2vqagsFWt6ruz8Hugy8hPF+FX0tyfrVGUr7yZCjSdZlooZb3km6v/ZSIhmtvfCM
	vFBkz3Mn0OoSuTwKkpC9w==
MIME-Version: 1.0
In-Reply-To: <20090602090944.GB16753@linux.vnet.ibm.com>
References: <200906020602.n5262wcu008560@imap1.linux-foundation.org>
	 <20090602090944.GB16753@linux.vnet.ibm.com>
Date: Tue, 2 Jun 2009 09:08:04 -0700
Message-ID: <6599ad830906020908s7cb6afe6pd83ca35b82d148a4@mail.gmail.com>
Subject: Re: + cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem. 
	patch added to -mm tree
From: Paul Menage <menage@google.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, lizf@cn.fujitsu.com,
       balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
       lkml <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       libcg-devel <libcg-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 2, 2009 at 2:09 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
>
> I am not sure if this is a good idea. For libcgroup, we would then be
> adding a special case for just cpuset. I would rather that we allow it
> either for all the subsystems or none of them.
>

libcgroup shouldn't be using the noprefix option. Its only intentded
use is to allow the legacy "cpuset" filesystem type to be mounted and
to see the same fileset as it had before the cgroups transition.

Paul
