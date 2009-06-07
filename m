Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbZFGAV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbZFGAV4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 20:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbZFGAVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 20:21:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:22752 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbZFGAVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 20:21:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=b/bDPXc0VSP22vFoBZLA0Ffd7X72LF45B4o8X24jfRW9pQyrqRLr7ZwVj6nE2/I3ZU
         YMxxTCI+wjTsuFUXRga7v8RqfhUxahRNo5xAgVOnKaHUlzTGGKQPdjHtnzBUxf0RyVR9
         jb6dILchTL5HYk92W3UR+M5D8NECTBdX1BUew=
Subject: Re: [ANN] Atheros 802.11n USB firmware source code released
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org, otus-devel@venema.h4ckr.net,
       David Woodhouse <dwmw2@infradead.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1244326943.12159.5.camel@localhost>
References: <43e72e890906051204q22278e4cw6beeae27da50e988@mail.gmail.com>
	 <1244326943.12159.5.camel@localhost>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 03:21:42 +0300
Message-Id: <1244334102.16810.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-07 at 01:22 +0300, Maxim Levitsky wrote:
> On Fri, 2009-06-05 at 12:04 -0700, Luis R. Rodriguez wrote:
> > I'm pleased to announce we have released the source code to our
> > Atheros 802.11n USB Otus/ar9170 device under the GPL. You can grab the
> > source, compile and use it with the upstream ar9170 device driver.
> > Patches are welcomed. The git tree available for this is at:
> > 
> > http://git.sipsolutions.net/ar9170-fw.git
> > 
> > For more information please visit the home page for this project is on
> > our Linux wireless wiki:
> > 
> > http://wireless.kernel.org/en/users/Drivers/ar9170.fw
> > 
> > The ar9170 device driver home page is at:
> > 
> > http://wireless.kernel.org/en/users/Drivers/ar9170
> > 
> > I'd like to thank Johannes Berg and Christian Lamparter for their
> > incredible contributions to the project both firmware and ar9170
> > driver so far without which this would not have been possible.
> 
> I just want to say thanks!
> 
> I will buy this device very soon.
> Is this source for same firmware that was closed?
> Will AP mode work in future?
> 
> If you were to release the documentation, then it would be really
> possible to fix AP mode for this firmware.
> 
> 
> If you could just release ath5k documentation.... I would fix its
> numerous problems I have with my aspire one (AR2425)...
> 
> 
> Best regards,
> 	Maxim Levitsky
> 

What does this mean:

eeprom   : ORIGIN = 0x000000, LENGTH = 1024k


Does the device have whole 1M of eeprom?
What is there?


Also what is this:

sram     : ORIGIN = 0x100000, LENGTH = 64k



Description says that pram is 32K, but:
 
pram     : ORIGIN = 0x200000, LENGTH = 16k


Best regards,
	Maxim Levitsk

