Return-Path: <linux-kernel-owner+w=401wt.eu-S1752054AbZJ1Ju6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbZJ1Ju6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 05:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZJ1Ju5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 05:50:57 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:35231 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbZJ1Ju4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 05:50:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:cc:subject;
        b=Q+gYXt2HwxRaJuDoH0/QSdAD3n0i0y9lHXmX40zKel1maZYkujexEDmTGqoOLaL0cZ
         3f5DvRtoRItyox0ZQGrXEDSZrHfRBepKC0yqAzPQIGFXB//Rlptfm3XgdPWjU5nLYukU
         beDibkuBtHKznWMgLwdLwPH7/MIMWqjK+jcxQ=
Message-Id: <20091028094324.010816897@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 28 Oct 2009 10:43:24 +0100
From: bart.hartgers@gmail.com
To: Greg Kroah-Hartman <gregkh@suse.de>, Mike McCormack <mikem@ring3k.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] ark3116: (v2) driver rework after review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I updated my ark3116 patches after the review on the list. The main
change is the removal of the atomic_t fields and addition of a spinlock.

This patch set brings the ark3116 driver up to date by:
- replacing the magic numbers by proper uart register accesses
- introducing locking
- line error handling
- interrupt based modem status handling
- cts/rts handshaking
- break signaling

The patches are against 2.6.32-rc4.

Mike: do you still want to combine these with yours?: if so, let me
know if I can help with merging them.

Groeten,
Bart
-- 
