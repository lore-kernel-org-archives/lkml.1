Return-Path: <linux-kernel-owner+w=401wt.eu-S932109AbXF1VoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbXF1VoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 17:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762391AbXF1Vny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 17:43:54 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:50959 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760384AbXF1Vnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 17:43:53 -0400
Date: Thu, 28 Jun 2007 23:43:51 +0200
From: DervishD <lkml@dervishd.net>
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: USB card reader and HAL
Message-ID: <20070628214351.GA9632@DervishD>
Mail-Followup-To: Linux-kernel <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi all :)

    I have a new card reader (internal) but I've tested with my old one
too: the same happens. I have a do-it-yourself linux box, self compiled
kernel 2.6.19.5 (by now).

    When I insert a card in the reader, it is not detected, no udev
event is generated and I have to do things like "hdparm -z /dev/sda" to
"probe" the card. Moreover, I have to do the same when removing the card
or the /dev/sdaX nodes are not deleted.

    Is HAL the only way of making it work? Is there any CONFIG_ thing
I've forgotten in my kernel?

    I've tested with Ubuntu and it works perfectly, and that's why I
think this may be HAL related (I don't have HAL installed, Ubuntu has).

    Thanks in advance :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
