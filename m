Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbZDUFHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbZDUFHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 01:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbZDUFHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 01:07:07 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:15746 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbZDUFHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 01:07:05 -0400
Date: Tue, 21 Apr 2009 07:10:03 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: spock@gentoo.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] fbdev: fix fillrect for 24bpp modes
Message-Id: <20090421071003.ded2ae3f.krzysztof.h1@poczta.fm>
In-Reply-To: <20090418185234.GA17853@tria>
References: <20090413170954.GA8403@tria>
	<20090417183617.ed7553cd.krzysztof.h1@poczta.fm>
	<20090417115048.0c5ca35d.akpm@linux-foundation.org>
	<20090418185234.GA17853@tria>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
X-EMID: ece2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Apr 2009 20:52:34 +0200
Michal Januszewski <spock@gentoo.org> wrote:

> The software fillrect routines do not work properly when the number of
> pixels per machine word is not an integer.  To see that, run the following
> command on a fbdev console with a 24bpp video mode, using a non-accelerated
> driver such as (u)vesafb:
> 
>   reset ; echo -e '\e[41mtest\e[K'
> 
> The expected result is 'test' displayed on a line with red background.
> Instead of that, 'test' has a red background, but the rest of the line
> (rendered using fillrect()) contains a distored colorful pattern.
> 
> This patch fixes the problem by correctly computing rotation shifts.
> It has been tested in a 24bpp mode on 32- and 64-bit little-endian
> machines.
> 
> Signed-off-by: Micha³ Januszewski <spock@gentoo.org>
> ---

I have tested the patch and it has worked with padded lines.

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>

However, there is  a comment from Andrew Morton.

Regards,
Krzysztof

----------------------------------------------------------------------
Gotowka na koncie. Otworz konto direct i wez podwojny limit.
http://link.interia.pl/f2115


