Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbYKGHOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbYKGHOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 02:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYKGHON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 02:14:13 -0500
Received: from mail-gx0-f11.google.com ([209.85.217.11]:44983 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbYKGHOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 02:14:12 -0500
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Nov 2008 02:14:12 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YNDKfHcIZVZ+BxEOs7o6eqCOK806GASDc+zRMFvYcfUx28VPUzqW3YjDsDQqUC5HeJ
         l24AYPgIwk8pjRy5nLFOIVIglCUDUC/ByjpsHrPuKDFl8aOSvdm4unYCz2bbQvFleX/6
         iKabdsng2Zofa8OXY4tyLBZ98EwVfjzjxxueg=
Message-ID: <8bd0f97a0811062309m4029f612k4d3fe380e6d124df@mail.gmail.com>
Date: Fri, 7 Nov 2008 02:09:04 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [PATCH] ALSA: have snd_BUG_ON() always refer to arguments
Cc: "Mike Frysinger" <vapier@gentoo.org>, alsa-devel@alsa-project.org,
       "Jaroslav Kysela" <perex@perex.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <s5hod0sqcmt.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226023521-10037-1-git-send-email-vapier@gentoo.org>
	 <s5hod0sqcmt.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 7, 2008 at 01:22, Takashi Iwai wrote:
> At Thu,  6 Nov 2008 21:05:21 -0500,
> Mike Frysinger wrote:
>> The snd_BUG_ON() macro should always expand its argument even if we're
>> forcing it to false.  This kills off unused warnings that did not exist
>> before the snd_assert() -> snd_BUG_ON() conversion.
>
> Andrew already change this differently.  Check with the latest version.

what are you defining as "latest version" ?  i'm looking in torvalds
linux-2.6.git.

> And which warning did you get actually?

a few codecs define local vars which only get used in snd_BUG_ON() ...
so if snd_BUG_ON() doesnt utilize cond, gcc whines that the var is
unused.
-mike
