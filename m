Return-Path: <linux-kernel-owner+w=401wt.eu-S1759201AbXKMHK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201AbXKMHK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 02:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbXKMHKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 02:10:21 -0500
Received: from smtp-out.google.com ([216.239.33.17]:12170 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbXKMHKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 02:10:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=WSOMgyrtDozV3qlNeJ13ojuMp95LRDRiZMuSgNzOVfNQQp8v0m2CMKVTM5ENBiPyR
	0ISfBRuA52TvNJ7CXUk3w==
Message-ID: <6599ad830711122310nf7530cfs5ef1fea061b1252c@mail.gmail.com>
Date: Mon, 12 Nov 2007 23:10:11 -0800
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: Revert for cgroups CPU accounting subsystem patch
Cc: vatsa@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <47394B84.8030008@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6599ad830711122125u576e85a6w428466a0ab46dbc6@mail.gmail.com>
	 <20071113060038.GC3359@linux.vnet.ibm.com>
	 <6599ad830711122205g88aae4fua8dd76cf6e8ab84d@mail.gmail.com>
	 <47394B84.8030008@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 12, 2007 11:00 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
> Right now, one of the limitations of the CPU controller is that
> the moment you create another control group, the bandwidth gets
> divided by the default number of shares. We can't create groups
> just for monitoring.

Could we get around this with, say, a flag that always treats a CFS
schedulable entity as having a weight equal to the number of runnable
tasks in it? So CPU bandwidth would be shared between groups in
proportion to the number of runnable tasks, which would distribute the
cycles approximately equivalently to them all being separate
schedulable entities.

> cpu_acct fills this gap.

Agreed, but not in the right way IMO.

Paul
