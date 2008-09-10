Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbYIJUPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbYIJUPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 16:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYIJUP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 16:15:28 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33306 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbYIJUPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 16:15:19 -0400
Date: Wed, 10 Sep 2008 16:15:17 -0400 (EDT)
From: Jan Engelhardt <jengelh@medozas.de>
To: sam@ravnborg.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kbuild: Unnecessary recompiles on path change
Message-ID: <alpine.LNX.1.10.0809101610210.11310@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I notice that my kernels get needlessy recompiled if I access the source 
tree through a different directory. In other words, /lo/linux is the 
kernel tree, and `mount --bind /lo /home/jengelh/lo` is in effect.

I see the absolute path being stored in .*.o.cmd files, which seems like 
all the explanation I need. I do remember that I left a comment 
when something like that was afloating:
http://www.nabble.com/-RFC-PATCH-3-6--kbuild:-convert-include-and-source-paths-td17064364.html

As of v2.6.27-rc4-263-g5697a99, there's no gcov in (at least there is no 
such thing in my .config when bulit with ARCH=um), but the issue with 
absolute paths exists.


Jan
