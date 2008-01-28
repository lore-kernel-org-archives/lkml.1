Return-Path: <linux-kernel-owner+w=401wt.eu-S1758147AbYA1Sx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbYA1Sx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYA1Sxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:53:51 -0500
Received: from smtp03.mtu.ru ([62.5.255.50]:61516 "EHLO smtp03.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbYA1Sxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:53:50 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: Problem with ata layer in 2.6.24
To: Richard Heck <rgheck@bobjweil.com>, linux-kernel@vger.kernel.org
Date: Mon, 28 Jan 2008 21:53:42 +0300
References: <200801272122.21823.gene.heskett@gmail.com> <1201539043.31293.7.camel@zem> <1201540830.6526.19.camel@localhost> <200801281230.32910.gene.heskett@gmail.com> <alpine.LNX.1.00.0801281248190.13593@iabervon.org> <479E1D9E.3000900@bobjweil.com>
User-Agent: KNode/0.10.5
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20080128185345.CF0A51871238@smtp03.mtu.ru>
X-DCC-STREAM-Metrics: smtp03.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Heck wrote:

> Daniel Barkalow wrote:
>> Can you switch back to old IDE to get your work done (and to make sure
>> it's not a hardware issue that's developed recently)?
> I think it'd be really, REALLY helpful to a lot of people if you, or
> someone, could explain in moderate detail how this might be done. I
> tried doing it myself, but I'm not sufficiently expert at configuring
> kernels that I was ever able to figure out how to do it.
> 

well, here on Mandriva I

1) compile both IDE and libata as modules
2) create initrd that contains either IDE or libata modules
3) use labels for file system mounts, swaps and resume device.


Now 1) should be pretty straightforward (I could send you config if you
like, it is stripped down to bare minimum on my system, you will have to
check drivers for your hardware). 2 and 3 are obviously distribution
dependent. I can explain how to do it on Mandriva that ATM has near to
perfect support for addressing devices via label/UUID; also ide/scsi/ata
switch is trivial using Mandriva mkinitrd. 

-andrey

> Obviously, the short version is: switch back to Fedora 6. But this kind
> of problem with libata---and yes, you're almost surely right that it's
> not one problem but lots---is sufficiently widespread that a Mini HOWTO,
> say, would be really welcome and, I'm guessing, widely used.
> 
> Richard
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


