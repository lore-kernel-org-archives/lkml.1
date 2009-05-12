Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbZELJmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbZELJmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbZELJmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:42:12 -0400
Received: from mail-qy0-f129.google.com ([209.85.221.129]:33941 "EHLO
	mail-qy0-f129.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbZELJmM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:42:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=H6Ufuj+TsBZPPpT2AnkO+1uOSWppMYuymvZAi7sWQCQn607Qh0P+ECHxKWCHyLVhm5
         a089B8cHQmJoRfTYXlp1HhPNE4L1lKTgF7h27HLCfqJCJ/MaJWsR9i/Ld5VnNN1pOkOk
         1sSgAkGkG4OUzAIZI9eQyhX+bjV8EeowV+yGg=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0905121023100.25624@venus.araneidae.co.uk>
References: <Pine.LNX.4.64.0905110928410.10720@venus.araneidae.co.uk>
	 <f17812d70905110734o3bbb716fjabc61c748904b1ec@mail.gmail.com>
	 <Pine.LNX.4.64.0905121023100.25624@venus.araneidae.co.uk>
Date: Tue, 12 May 2009 17:42:11 +0800
Message-ID: <f17812d70905120242s2baa41edx8ab66b4b921dbbff@mail.gmail.com>
Subject: Re: [PATCH 1/2] XCEP PXA255 Processor Board
From: Eric Miao <eric.y.miao@gmail.com>
To: Michael Abbott <michael@araneidae.co.uk>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > +MACHINE_START(XCEP, "Iskratel XCEP")
>> > +       .phys_io        = 0x80000000,
>> > +       .io_pg_offst    = 0xf8000000,
>> ...... you sure this is correct? Please have a reference to other platforms.
> Now this is very odd.  I've updated these two fields to conform to other
> PXA architectures ... but it looks as if these fields don't actually make
> any difference.  I dug a little, and the only place I could find them
> being used is in arch/arm/kernel/head.S (as MACHINFO_PGOFFIO and _PHYSIO),
> and only there if CONFIG_DEBUG_LL is defined.
>

You are right on this. These are mostly used for the initial mapping
of the IO registers so that low-level debug output like UART output
can work at the very early stage. You will find this very handful if
you are debugging on early bring-up.
