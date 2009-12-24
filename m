Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbZLXLmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbZLXLmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 06:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757313AbZLXLmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 06:42:53 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:61896 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757269AbZLXLmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 06:42:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YoqssV6Juvf/TdjULTSr8F9Py09THb+Cex8AJbGrpphk4DuLtWXPZr/jjWoYkL6N5/
         /yAaZ57FIRDTOM12MoZHc/R3y4ZIPMuN8+G/3KPy9A7I0A/AaYozf5fbhiPc6c+LsU7K
         D/Ac9NnGWgCuypu7wFo1rE6DpXpQuEg4M+rfo=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matti Aarnio <matti.aarnio@zmailer.org>
Subject: USB: ftdi_sio: two bug fixes and some clean up
Date: Thu, 24 Dec 2009 12:42:06 +0100
Message-Id: <1261654931-31543-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6.rc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

These patches fix two bugs in fdti_sio and do a bit of clean up. The DMA to
stack bug was reported by Matti Aarnio here:

  http://thread.gmane.org/gmane.linux.usb.general/22845

The patches are against Linus' tree of today with all (4) ftdi patches from
Greg's tree applied.

Cheers,
Johan


 USB: ftdi_sio: use error code from usb stack in read_latency_timer
 USB: ftdi_sio: fix latency-timeout endianess bug
 USB: ftdi_sio: fix DMA buffers on stack
 USB: ftdi_sio: clean up modem status handling
 USB: ftdi_sio: remove unnecessary initialisations
 
 drivers/usb/serial/ftdi_sio.c |  137 ++++++++++++++++++-----------------------
 1 files changed, 61 insertions(+), 76 deletions(-)


