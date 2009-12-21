Return-Path: <linux-kernel-owner+w=401wt.eu-S1751142AbZLUFmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142AbZLUFmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 00:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbZLUFmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 00:42:21 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:53654
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbZLUFmU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 00:42:20 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: kernel list <linux-kernel@vger.kernel.org>
Subject: Why is ARCH m68k hardwired into drivers/net/wan/Makefile?
Date: Sun, 20 Dec 2009 23:42:16 -0600
User-Agent: KMail/1.11.2 (Linux/2.6.28-16-generic; KDE/4.2.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200912202342.16806.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone have an opinion on this?

>From drivers/net/wan/Makefile:

>ifeq ($(ARCH),m68k)
>  AS68K = $(AS)
>  LD68K = $(LD)
>else
>  AS68K = as68k
>  LD68K = ld68k
>endif

-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
