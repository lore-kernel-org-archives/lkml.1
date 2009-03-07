Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbZCGSy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbZCGSy5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 13:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbZCGSyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 13:54:49 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:34472 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588AbZCGSyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 13:54:49 -0500
Date: Sat, 7 Mar 2009 19:54:45 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: David Miller <davem@davemloft.net>
Subject: Change %Z to %z in printf
Message-ID: <alpine.LSU.2.00.0903071952180.19385@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I found out that %Z is actually a deprecated libc5-ism as printf(3) of 
man-pages 3.17 dated 2008-12-19 tells me.

In ${kernel}/lib/vsprintf.c, I find the following note and wondered
if there might be any objections to going back to 'z'.

        int qualifier;          /* 'h', 'l', or 'L' for integer fields */ 
                                /* 'z' support added 23/7/1999 S.H.    */ 
                                /* 'z' changed to 'Z' --davidm 1/25/99 */ 
                                /* 't' added for ptrdiff_t */ 


Jan
