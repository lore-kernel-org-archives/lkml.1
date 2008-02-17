Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbYBQTb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbYBQTb6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbYBQTbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:31:50 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:41101 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbYBQTbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:31:49 -0500
Date: Sun, 17 Feb 2008 20:31:59 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] modpost: Fix reversed symbol name order
Message-ID: <20080217193159.GI14588@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0802171411400.19269@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802171411400.19269@anakin>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 02:12:10PM +0100, Geert Uytterhoeven wrote:
> XXXINIT_TO_INIT and XXXEXIT_TO_EXIT warnings use the reversed symbol name order
> in the suggestion, e.g.:
> 
>     WARNING: vmlinux.o(.meminit.text+0x36c): Section mismatch in reference from the function free_area_init_core() to the function .init.text:setup_usemap()
>     The function __meminit free_area_init_core() references
>     a function __init setup_usemap().
>     If free_area_init_core is only used by setup_usemap then
>     annotate free_area_init_core with a matching annotation.
> 

Ups - applied.

Thanks,

	Sam
