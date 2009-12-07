Return-Path: <linux-kernel-owner+w=401wt.eu-S935739AbZLGXHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935739AbZLGXHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 18:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935719AbZLGXHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 18:07:39 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:52948 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935690AbZLGXHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 18:07:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=r16WUtGmSReqpDQUtMioYTUpix7futxtDvfqTiOBmr+nJwAUs+wdQwX0kq70fmBq5u
         XuxN7hKDB649dt1JK9JuGVBkQeKi8yD9FlqPJLL9OQSBmUQK2kV6sOiaF1lQ0M2D1sUZ
         xHHPhQ4GZa6IsGCVhxQluaby8XEydXG2MVCt4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
Subject: [Updated]iMac_91_sound_patch.
Date: Mon,  7 Dec 2009 15:07:45 -0800
Message-Id: <1260227266-6206-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



This is an updated patch for the Apple iMac 9,1 model to add sound.
Original patch posted here:
http://article.gmane.org/gmane.linux.alsa.devel/61361/match=

I have been using this patch for a while now
and have to say it works vary well, except for a few minor 
things:

	With the iMac 24-inch 3.06GHz Intel Core 2 Duo
	everything seems to be working as it should,
        although I have not looked into the microphone
	(never really use one, nor have any apps to test,
	my guess is it doesn't work, or I never figured out how
	to get it to work).

	With the iMac 24-inch 2.66GHz Intel Core 2 Duo
	everything is the same as with the above machine 
	except I'm hearing a light scratchy/distortion noise
	come out of the speakers when using headphones(above machine
	does not do this).

Other than that the sound level is great(especially with good Dj headphones).

Now onto this patch. I took the liberty of sighning off on it
although I don't feel comfortable doing so, since this is not my
work(except for a few changes to fit the latest kernel).
In reading:
http://article.gmane.org/gmane.linux.alsa.devel/61596/match=
there was mention of a sign off, but something happened. 

Anyways I'll leave it up to the people in charge of patches
to make the descision on what to do with this. 


 Documentation/sound/alsa/HD-Audio-Models.txt |    1 +
 sound/pci/hda/patch_realtek.c                |  111 ++++++++++++++++++++++++++
 2 files changed, 112 insertions(+), 0 deletions(-)



