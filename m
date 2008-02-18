Return-Path: <linux-kernel-owner+w=401wt.eu-S1759209AbYBRRh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209AbYBRRh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 12:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbYBRRhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 12:37:50 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:27563 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752261AbYBRRhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 12:37:50 -0500
Date: Mon, 18 Feb 2008 20:37:45 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Valdis.Kletnieks@vt.edu
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>,
       linux-fbdev-devel@lists.sourceforge.net,
       Geert Uytterhoeven <geert@linux-m68k.org>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] [PATCH 1/2] fb: add support for foreign endianness
Message-ID: <20080218173745.GA25628@localhost.localdomain>
Reply-To: avorontsov@ru.mvista.com
References: <20080205154432.GA8749@localhost.localdomain> <20080214224942.a0cb6218.akpm@linux-foundation.org> <20080215164542.GB16810@localhost.localdomain> <Pine.LNX.4.64.0802171030330.6848@anakin> <20080218081847.e9e65f2f.krzysztof.h1@poczta.fm> <19805.1203355811@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <19805.1203355811@turing-police.cc.vt.edu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 12:30:11PM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 18 Feb 2008 08:18:47 +0100, Krzysztof Helt said:
> > I know two fb drivers which use endianess information (pm2fb and s3c2410fb).
> > Both resolve endianess at driver level. Actually, both handle it by setting special
> > bits so the graphics chip itself reorder bytes to transform foreign endianess. 
> > I understand that this patch is for chips which cannot reorder bytes by themselves.
> 
> Does anybody know of such a chip that's actually available in the wild?

LE Fujitsu mb86277 (MINT) on the BE MPC8360E.

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.net/bd2
