Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbZJYRxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbZJYRxO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 13:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbZJYRxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 13:53:13 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:64063 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbZJYRxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 13:53:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:cc:subject;
        b=S8rlej4ypx9Wf+Z1xKowzPm04D1SCfpimFRVCQAvzZ2xf6a+tEG7ymTXnCTtK9aZqM
         dIWF3UqFTAY2C6EWVlRuawCy58kn7XmJc9iwsFeeP3SjR38BZA/AppHDTOkrnGtCZ4jK
         ZDTDA231+3q0yK1zdNGJxHd3x1FxG/AsrgdY8=
Message-Id: <20091025175057.270011110@gmail.com>
User-Agent: quilt/0.46-1
Date: Sun, 25 Oct 2009 18:50:57 +0100
From: bart.hartgers@gmail.com
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] ark3116: (3rd try) driver rework
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Third try in getting my patches to the list. Somehow send to myself
worked, but vger seems to choke on something.


Anyhow:

Here is the patch set I metioned earlier. It brings the ark3116 driver
up to date by:
- replacing the magic numbers by proper uart register accesses
- introducing locking
- line error handling
- interrupt based modem status handling
- cts/rts handshaking
- break signaling

The patches are against 2.6.32-rc4.

Groeten,
Bart
-- 
