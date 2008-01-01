Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbYAAT5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbYAAT5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 14:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbYAAT5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 14:57:12 -0500
Received: from fmmailgate04.web.de ([217.72.192.242]:56198 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbYAAT5M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 14:57:12 -0500
Date: Tue, 01 Jan 2008 20:57:08 +0100
Message-Id: <80365890@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Subject: [BUG] crash - modules l440gx and parport_pc interfere
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18u1hb1eHlQDYnlOoDJjUZ925NYm16V5vP9dn0Jelqlv8eUH
 apobAE9lq+912or6NavCY9Ui0udaO3Yud5ZchNhs9XkLw+MlFY=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

there seems some weird interference between l440gx and parport_pc modules

i can reproduceable crash my box by either:

modprobe parport_pc;modprobe l440gx;rmmod parport_pc

or

modprobe l440gx; modprobe parport_pc;rmmod parport_pc

this happens on 2.6.24rc6 and also older kernel (2.6.22)

nothing in dmesg - just 
>JEDEC: Found no L440GX BIOS device at location zero
>JEDEC probe on BIOS chip failed. Using ROM

because i haven`t appropriate hardware.

don`t know if this is a bug in parport_pc or l440gx but maybe its worth reporting.

regards
roland
_______________________________________________________________________
Jetzt neu! Schützen Sie Ihren PC mit McAfee und WEB.DE. 30 Tage
kostenlos testen. http://www.pc-sicherheit.web.de/startseite/?mc=022220

