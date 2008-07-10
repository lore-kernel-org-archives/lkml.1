Return-Path: <linux-kernel-owner+w=401wt.eu-S1759272AbYGJQrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272AbYGJQrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 12:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbYGJQrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 12:47:00 -0400
Received: from smtp-out.google.com ([216.239.33.17]:32620 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbYGJQrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 12:47:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=iH/6pXz2NmmfFp3LfXwLuRIiWbQKeBukugKu5TW4vVOQCwPwfIINckbkmHdq2eFV9
	ePrfj+C48wwm3im+KJwYQ==
Message-ID: <6599ad830807100946j6db8d0d6se18f1b428c69ad5c@mail.gmail.com>
Date: Thu, 10 Jul 2008 09:46:46 -0700
From: "Paul Menage" <menage@google.com>
To: "Vivek Goyal" <vgoyal@redhat.com>
Subject: Re: [RFC] How to handle the rules engine for cgroups
Cc: "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Libcg Devel Mailing List" <libcg-devel@lists.sourceforge.net>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Peter Zijlstra" <pzijlstr@redhat.com>, kamezawa.hiroyu@jp.fujitsu.com,
       "Kazunaga Ikeno" <k-ikeno@ak.jp.nec.com>,
       "Morton Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080710143307.GD3782@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080701191126.GA17376@redhat.com>
	 <6599ad830807100207q26cf2416qb8d38d1d715b5ba0@mail.gmail.com>
	 <20080710143307.GD3782@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 7:33 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>
> We also need to do something to track all the forked childs after
> the setuid, setgid or exec till original parent event got classified
> and children need to meet the same treatment.

You'd get that automatically, since children of the task moved to the
root cgroup (indicating "needs attention") would also end up in that
cgroup since cgroup are inherited across fork.

Paul
