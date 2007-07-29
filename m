Return-Path: <linux-kernel-owner+w=401wt.eu-S1764678AbXG2O7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764678AbXG2O7v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 10:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763024AbXG2O5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:57:25 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45772 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764025AbXG2O5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:57:23 -0400
Date: Sun, 29 Jul 2007 16:57:22 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alexey Dobriyan <adobriyan@sw.ru>
cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] .gitignore update
In-Reply-To: <20070726121547.GA16937@localhost.sw.ru>
Message-ID: <Pine.LNX.4.64.0707291656380.9488@fbirervta.pbzchgretzou.qr>
References: <20070726121547.GA16937@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 26 2007 16:15, Alexey Dobriyan wrote:
>
>Somehow I ended up with the following in tree:
>
>	$ git status
>		...
>	# Untracked files:
>	#   (use "git add <file>..." to include in what will be committed)
>	#
>	#       fs/proc/root.o.FuMxJQ
>	#       net/ipv4/tcp_minisocks.o.geCDYR
>
>These are presumably temporary gcc files, which aren't interesting.

But they should not be there by default! Or are they?
Looks like an interrupted assembler stage or so.
So I do not think *.o.* should be added.


	Jan
-- 
