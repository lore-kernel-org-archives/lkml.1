Return-Path: <linux-kernel-owner+w=401wt.eu-S1761544AbYDNPr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761544AbYDNPr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbYDNPrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:47:21 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:44977 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbYDNPrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:47:21 -0400
Message-ID: <48037C55.7060105@freescale.com>
Date: Mon, 14 Apr 2008 10:46:29 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: linuxppc-dev@ozlabs.org, York Sun <yorksun@freescale.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Driver for Freescale 8610 and 5121 DIU
References: <12053582234100-git-send-email-yorksun@freescale.com>	<12053582231281-git-send-email-yorksun@freescale.com>	<47D8572C.8090501@gmail.com>	<47FFDBFF.1030809@gmail.com>	<20080411221817.0b1eb414.akpm@linux-foundation.org>	<48035E93.6070300@freescale.com> <48035F98.1020404@gmail.com>	<48036001.10905@freescale.com> <4803620C.6020905@gmail.com>	<48036649.6000409@freescale.com> <4803690A.3080105@gmail.com> <48036F00.6080200@freescale.com> <48037BA4.6070201@gmail.com>
In-Reply-To: <48037BA4.6070201@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:

> Mainly because you can sleep inside locked mutex and because spinlock shouldn't
> be used for too many lines of code (busy waiting etc.). I think ldd3 will be
> more descriptive than me here :).

Ok, I'll look into it.

Andrew, do you want us to respin the patch, or would you be willing to let us
make the change in a follow-up patch?

-- 
Timur Tabi
Linux kernel developer at Freescale
