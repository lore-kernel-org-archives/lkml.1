Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbXITBv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbXITBv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 21:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbXITBvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 21:51:49 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:63233 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbXITBvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 21:51:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ha0XAB55TadZZABXYJDVF3aHl3OpQSJh2bFgoe3cVuRKZ+1fNI5bZa1I2E5vP4gcta6cxyRFcaT5WDjpvXftGwG5y9U58+mAYSb85cYwAZrijT7sTAVHAP33v7HdyGgGVyXYTpue5Jx5d78tNYvMOHRTU3Masj0ptIe+MLaHCR4=
Message-ID: <21d7e9970709191851s1b3f35c1j42faae3ce6cd0b24@mail.gmail.com>
Date: Thu, 20 Sep 2007 11:51:47 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <46F17F27.5080000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	 <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com>
	 <46F13938.1070709@gmail.com>
	 <20070919121017.0cbcbc30.akpm@linux-foundation.org>
	 <20070919192453.GB18707@one.firstfloor.org>
	 <46F17CA1.5080205@gmail.com>
	 <20070919195425.GF18707@one.firstfloor.org>
	 <46F17F27.5080000@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/20/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 09/19/2007 09:54 PM, Andi Kleen wrote:
> >> Yeah. (But X doesn't run -- this is maybe the known issue in this release).
> >
> > What do you mean with not run?
>
> (II) intel(0): Initializing HW Cursor
> (II) intel(0): xf86BindGARTMemory: bind key 0 at 0x005ff000 (pgoffset 1535)
> (WW) intel(0): xf86BindGARTMemory: binding of gart memory with key 0
>         at offset 0x5ff000 failed (Invalid argument)
>
> Fatal server error:
> Couldn't bind memory for front buffer
>
> I thought I'd seen a thread about this issue, but I can't find it now. Is it
> known or am I seeing ghosts yet, Andrew?
>

Can you send me a complete Xorg log file?

and lspci -vv?

my 945 works fine with my drm tree on top of Linus with clflush + my
agp fix I just sent out ..

Dave.
