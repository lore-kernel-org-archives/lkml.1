Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbZCTUCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbZCTUCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 16:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbZCTUC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 16:02:28 -0400
Received: from mail-gx0-f208.google.com ([209.85.217.208]:50651 "EHLO
	mail-gx0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZCTUC1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 16:02:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KYuSW2PS9COwye/o06AV8llx4JpQDKIKAMFpLL4XtefO/Hrh3EjhZA75Pyxvofl8+c
         wGXrssOScWwpfTpIxxRN3vYn9W7dw15MWc2O+eXaRctS2BHaBt0AypxAZC1LExdW3woF
         CV4Tv2SZ7SlqDvGI3clVFP+TDr8IoMuFqBU0o=
MIME-Version: 1.0
In-Reply-To: <1237578912.26159.13.camel@T60p>
References: <1237575285.26159.2.camel@T60p>
	 <412bdbff0903201228t4cb4b6c8m17763c27878434ed@mail.gmail.com>
	 <1237578912.26159.13.camel@T60p>
Date: Fri, 20 Mar 2009 16:02:25 -0400
Message-ID: <412bdbff0903201302ib6758a8ue76a8dd235cfa4cb@mail.gmail.com>
Subject: Re: [PATCH] V4L: em28xx: add support for Digitus/Plextor PX-AV200U 
	grabbers
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Mikhail Jiline <misha@epiphan.com>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
       video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 3:55 PM, Mikhail Jiline <misha@epiphan.com> wrote:
>> Is this patch incomplete?  Where is the registration for the USB ID of
>> the device?
>
> The patch is complete. This device (as many others) doesn't have unique
> VID/PID, it uses generic eb1a:2821, which is already associated with
> ex28xx (see drivers/media/video/em28xx/em28xx-cards.c:1103)
>
> Regards,
> Misha.

Yeah, something still seems wrong here.  In cases where the device
uses one of the Empia generic USB ids, you need to have either an i2c
hash entry of an eeprom hash entry.  That's how it knows which device
to associate it with in those cases.

Did you try this patch?  If so, can you send the full dmesg output
after connecting the device?

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
