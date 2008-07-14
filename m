Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbYGNTIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbYGNTIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 15:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbYGNTIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 15:08:31 -0400
Received: from rn-out-0910.google.com ([64.233.170.186]:13970 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbYGNTIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 15:08:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QUPZLqWVJ1SnFHQgvUE3cBfWfZHqJAasrLj+faDShEBkaXcd8skmPrZgPBYn1mTvlu
         ewM/SPOlF2YHioC28TpiqaW51lOXUdqmgF3BuEm8+feLF/Ub7jGXQJWxP/kt+q2pL5nq
         rxzJ/gX06lAG+HlYkOjfbQeKvs5sIWNk4GG0Q=
Message-ID: <86802c440807141208u5108f7d9q23ec8cbf41ec59df@mail.gmail.com>
Date: Mon, 14 Jul 2008 12:08:30 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Find offset for crashkernel reservation automatically
Cc: "Bernhard Walle" <bwalle@suse.de>, "Vivek Goyal" <vgoyal@redhat.com>,
       kexec@lists.infradead.org, x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <m1iqv8xpll.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214510048-21215-1-git-send-email-bwalle@suse.de>
	 <86802c440807140011v728cc35fy2540b537ddca9844@mail.gmail.com>
	 <20080714112404.36783df5@halley.suse.de>
	 <m1od50ztoa.fsf@frodo.ebiederm.org>
	 <86802c440807141006o98afac8t66b0933d8acd2746@mail.gmail.com>
	 <m17iboz83v.fsf@frodo.ebiederm.org>
	 <86802c440807141117q218fdd61w1216dc6ded72252a@mail.gmail.com>
	 <m1r69wxq8v.fsf@frodo.ebiederm.org>
	 <20080714204748.07b06e30@halley.suse.de>
	 <m1iqv8xpll.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 11:55 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Bernhard Walle <bwalle@suse.de> writes:
>
>> But such checks belong into kexec itself, not into the kernel.
>
> Exactly.
>
> All we should do in the kernel is bias the search for a low address.
> As that is more usable.

let kexec to uncompress the bzImage (need to check if header version
is 2.0.8(?) above?) , if the kdump_base is above 4g.

YH
