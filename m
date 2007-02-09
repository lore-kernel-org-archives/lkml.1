Return-Path: <linux-kernel-owner+w=401wt.eu-S1946508AbXBIPLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946508AbXBIPLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946520AbXBIPLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:11:38 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:52691 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946508AbXBIPLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:11:37 -0500
Message-ID: <45CC8F2D.3070902@gmail.com>
Date: Fri, 09 Feb 2007 16:11:41 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Dmitry Torokhov <dtor_core@ameritech.net>
Subject: WHATIS scan_keyb
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

What's drivers/char/scan_keyb.{c,h} for, when it's referenced in no place (aside 
a fact, that it uses some old API and hence is broken)?

$ grep -r scan_keyb *
drivers/char/scan_keyb.c: *     $Id: scan_keyb.c,v 1.2 2000/07/04 06:24:42 
yaegashi Exp $
drivers/char/scan_keyb.c:struct scan_keyboard {
drivers/char/scan_keyb.c:       struct scan_keyboard *next;
drivers/char/scan_keyb.c:static struct scan_keyboard *keyboards=NULL;
drivers/char/scan_keyb.c:       struct scan_keyboard *kbd;
drivers/char/scan_keyb.c:int register_scan_keyboard(int (*scan)(unsigned char 
*buffer),
drivers/char/scan_keyb.c:       struct scan_keyboard *kbd;
drivers/char/scan_keyb.c:       kbd = kmalloc(sizeof(struct scan_keyboard), 
GFP_KERNEL);
drivers/char/scan_keyb.h: *     $Id: scan_keyb.h,v 1.1 2000/06/10 21:45:30 
yaegashi Exp $
drivers/char/scan_keyb.h:int register_scan_keyboard(int (*scan)(unsigned char 
*buffer),

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
