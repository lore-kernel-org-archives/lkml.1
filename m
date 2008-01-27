Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbYA0Mpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbYA0Mpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 07:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYA0Mps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 07:45:48 -0500
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:43853 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752266AbYA0Mpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 07:45:47 -0500
X-Greylist: delayed 1491 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2008 07:45:47 EST
Date: Sun, 27 Jan 2008 13:25:10 +0100
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: spock@gentoo.org, linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] fbdev: make the best-fit section of
 fb_find_mode return the closest matching mode
Message-Id: <20080127132510.b00017cb.krzysztof.h1@poczta.fm>
In-Reply-To: <20080127113115.GA17722@spock.one.pl>
References: <20080127113115.GA17722@spock.one.pl>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: f4e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jan 2008 12:31:16 +0100
Michal Januszewski <spock@gentoo.org> wrote:

> From: Michal Januszewski <spock@gentoo.org>
> 
> Currently, if a perfect match in terms of resolution is not found,
> fb_find_mode() only looks for a best-fit mode among modes with a
> higher resolution than the one requested.  Thus, if the user
> requests a resolution higher than the largest supported one, they
> are dropped to the default mode (usually a low resolution one).
> 

> Change this behaviour so that the true closest match in terms
> of the city-block metric is returned.
> 

This may be not ideal solution in case there exist both lower and
higher matches. If given resolution is closer (even by few pixels)
to lower one, your method will choose the lower one.
It may be incorrect for e.g. picture viewer (the higher resolution
shows the whole picture with margins, the smaller one shows
rescaled or cut picture).

IMHO, the choice of higher resolution (if possible) should be
preferred. It is also closer to the old solution.

Kind regards,
Krzysztof


----------------------------------------------------------------------
Nadchodzi galaktyczna wojna!
Sprawdz >> http://link.interia.pl/f1ce0

