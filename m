Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbYDJKvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbYDJKvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 06:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbYDJKvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 06:51:22 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:43465 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508AbYDJKvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 06:51:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XzvB3PJtkfWThFiSwtwez84J1JLYWQdNccMr58mKWtzgDcuv58649pvg4Z0sjKAsGC9mmlJyAzMM5wcBdMpB6WveCITJI43IPv0EILY2+lbRCvtaJLqI/WqzfaVMSPsNqfBanQ9dXtFR1PihpoF5Qan3hQOZC3I7b4UQ9lkf3E8=
Message-ID: <5699f8f00804100351q427b1a0dxdeb8254b370cb8ed@mail.gmail.com>
Date: Thu, 10 Apr 2008 12:51:21 +0200
From: "Wander Winkelhorst" <w.winkelhorst@gmail.com>
To: "Wappler Marcel" <Marcel.Wappler@bridgeco.net>
Subject: Re: Starting point: Suspend to RAM on embedded devices?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <83116F0A4FF67A4F97BA0B6E408C48E301E96234@zuerich.BC-Int.NET>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <83116F0A4FF67A4F97BA0B6E408C48E301E96208@zuerich.BC-Int.NET>
	 <5699f8f00804100123q2a9d278arf9b076c91efbbd56@mail.gmail.com>
	 <83116F0A4FF67A4F97BA0B6E408C48E301E96234@zuerich.BC-Int.NET>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 11:53 AM, Wappler Marcel
<Marcel.Wappler@bridgeco.net> wrote:
> Wander Winkelhorst wrote:
>  > The TomTom portable navigation devices (TomTom one, TomTom go etc.)
>
> > They are based around an ARM CPU from Samsung and run Linux. If you
>  > press the "power button" it actually does a suspend-to-ram.
>
>  Do you have (or anybody else) experience, how long the wakeup from suspend to RAM does take? Would it be possible to have the fully
>  functional device with running aplication one second after pushing the power button?

Well, my tomtom one V2 takes a couple (5-10) of seconds to wake up
again. but that time includes reinitialising the bluetooth chip,
checking the SD card, restarting the GPS, loading AGPS data and
resuming the navigation software. If you don't have to do all those
things it would probably resume a lot faster.
