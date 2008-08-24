Return-Path: <linux-kernel-owner+w=401wt.eu-S1753243AbYHXD0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbYHXD0T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 23:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYHXD0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 23:26:09 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:4822 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbYHXD0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 23:26:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PKiPrIpmkGl01VwsAsdMFN7crbE+dauYvbhBsVQmqu5Y9GGEbyzNeeRs1JHeMOIjUr
         SUMb/G2xDpyGPMXtTX9IgcmlI2e1HrjUuTXHPiEj28pZ9dTZtrdpm5hmV+JNozwS5Xql
         /UB6a2iopsxXSm7v8CUPsTVPLMTUeCYrUE38Q=
Subject: Re: Segmentation fault details?
From: Calvin Walton <calvin.walton@gmail.com>
To: 7eggert@gmx.de
Cc: Wang Yi <leonidwang@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <E1KWzeO-0004TU-Hr@be1.7eggert.dyndns.org>
References: <aZzy0-8hH-13@gated-at.bofh.it> <aZzy0-8hH-15@gated-at.bofh.it>
	 <aZzxZ-8hH-11@gated-at.bofh.it>  <E1KWzeO-0004TU-Hr@be1.7eggert.dyndns.org>
Content-Type: text/plain
Date: Sat, 23 Aug 2008 23:26:04 -0400
Message-Id: <1219548364.15228.4.camel@zem>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-23 at 22:23 +0200, Bodo Eggert wrote:
> Wang Yi <leonidwang@gmail.com> wrote:
> 
> >  I'd like to know some details about segmentation fault.
> >  What I mean is when a program accesses invalid memory area, it will
> > get a SIGSEGV signal from kernel, and a message "Segmentation fault".
> > 
> >  I also find that dmesg can show we something like this:
> >  ProgramName[Pid]: segfault at xxxx eip xxxx esp xxxx error x
> >  It is useful and provides the first-step information for further
> > debug/analysis.
> > 
> >  My question is how dmesg gets the information, and if there are any
> > "decent" way to get this and maybe more information(An "indecent" way
> > I came to is grep dmesg)
> > so that I can perform some basic auto analysis.
> 
> I'm wondering if the default handler might print this information isntead
> of the plain segmentation violation.

If you want to debug a segfaulting user-space program, there's a
somewhat better way to get this information (and a whole lot more info,
too...), and it's been around in various unixes for ages: core dumps
(core files).

Unfortunately (but given the state of modern linux desktop programs,
understandably), most current linux distributions ship with core dumps
turned off. But it isn't too hard to turn them back on if you have a
segfaulting program that you want to debug.

-- 
Calvin Walton <calvin.walton@gmail.com>

