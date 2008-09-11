Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbYIKSIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbYIKSIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 14:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbYIKSH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 14:07:56 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:57928 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbYIKSH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 14:07:56 -0400
Date: Thu, 11 Sep 2008 14:07:53 -0400 (EDT)
From: Jan Engelhardt <jengelh@medozas.de>
To: Jeff Dike <jdike@addtoit.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, sam@ravnborg.org
Subject: Re: kbuild: Unnecessary recompiles on path change
In-Reply-To: <alpine.LNX.1.10.0809101610210.11310@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LNX.1.10.0809111404520.24368@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0809101610210.11310@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 2008-09-10 16:15, Jan Engelhardt wrote:

>Hi,
>
>I notice that my kernels get needlessy recompiled if I access the source 
>tree through a different directory. In other words, /lo/linux is the 
>kernel tree, and `mount --bind /lo /home/jengelh/lo` is in effect.
>
>I see the absolute path being stored in .*.o.cmd files, which seems like 
>all the explanation I need. I do remember that I left a comment 
>when something like that was afloating:
>http://www.nabble.com/-RFC-PATCH-3-6--kbuild:-convert-include-and-source-paths-td17064364.html
>
>As of v2.6.27-rc4-263-g5697a99, there's no gcov in (at least there is no 
>such thing in my .config when bulit with ARCH=um), but the issue with 
>absolute paths exists.

It seems that only ARCH=um builds have this issue.
