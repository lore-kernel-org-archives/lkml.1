Return-Path: <linux-kernel-owner+w=401wt.eu-S1760659AbYAaBC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760659AbYAaBC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 20:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbYAaBCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 20:02:21 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:57654 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbYAaBCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 20:02:20 -0500
Date: Thu, 31 Jan 2008 02:02:19 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: sam@ravnborg.org
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: oldconfig/menuconfig help text display for "choice" items
Message-ID: <Pine.LNX.4.64.0801310157050.13320@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


when running oldconfig, I got to see some new IO delay questions,
and tried displaying its info using ?.

	IO delay type
	  1. port 0x80 based port-IO delay [recommended] (IO_DELAY_0X80) (NEW)
	> 2. port 0xed based port-IO delay (IO_DELAY_0XED) (NEW)
	  3. udelay based port-IO delay (IO_DELAY_UDELAY) (NEW)
	  4. no port-IO delay (IO_DELAY_NONE) (NEW)
	choice[1-4]: ?

	Sorry, no help available for this option yet.


The IO_DELAY_* "config" items have a help text, while the "choice" 
item does not.
Are there any plans on 'fixing' oldconfig to somehow tell me something 
about such new options?


thanks,
Jan
