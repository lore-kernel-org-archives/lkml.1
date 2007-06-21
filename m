Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbXFUNt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbXFUNt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 09:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbXFUNtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 09:49:50 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:57048 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbXFUNtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 09:49:50 -0400
Message-ID: <467A81F6.5090500@s5r6.in-berlin.de>
Date: Thu, 21 Jun 2007 15:49:42 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: palindrom@skrzynka.pl
CC: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: menuconfig
References: <46798FDB.3020804@skrzynka.pl>
In-Reply-To: <46798FDB.3020804@skrzynka.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marcin Szczurowski wrote:
> I've just configured new kernel:
> 
> 2.6.21.1 + patch-2.6.21.5
> 
> In menuconfig:
> Networking -> Networking options -> IP: Virtual server configuration
> I've choosen help and got help to menuconfig...
> Hard to call it a bug, but I don't know what Virtual server 
> configuration stands for ;]

The menu "IP: Virtual Server Configuration" doesn't have a help text for
itself.  But the very first menu item in it (on which all other items
happen to depend on) has the following help text:
http://lxr.free-electrons.com/source/net/ipv4/ipvs/Kconfig?v=2.6.21#007

In Linux 2.6.22, the menu + the first menu item were fused into a
hybrid, a so-called menuconfig.  (Bad choice of term, but it wasn't
mine.  It's something different from the make menuconfig program.)
This fused menu+config item has exactly the same help text.
-- 
Stefan Richter
-=====-=-=== -==- =-=-=
http://arcgraph.de/sr/
