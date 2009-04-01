Return-Path: <linux-kernel-owner+w=401wt.eu-S932994AbZDARxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994AbZDARxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 13:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755612AbZDARxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 13:53:33 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:32392 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbZDARxc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 13:53:32 -0400
Date: Wed, 1 Apr 2009 18:54:48 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: spock@gentoo.org
Cc: linux-kernel@vger.kernel.org,
       Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
       Geert Uytterhoeven <geert.uytterhoeven@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] uvesafb: fix color component length for pseudocolor
 modes
Message-Id: <20090401185448.03c5260a.krzysztof.h1@poczta.fm>
In-Reply-To: <20090330220246.GA6894@spock.one.pl>
References: <20090330220246.GA6894@spock.one.pl>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-EMID: 66e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 00:02:46 +0200
Michal Januszewski <spock@gentoo.org> wrote:

> uvesafb incorrectly sets the length of the color fields to 6 bits
> for PSEUDOCOLOR modes, even though 8 bits are always used per pixel.
> Fix this by setting the length to 8.
> 
> The switch of the DAC width from the default 6 bits to 8 bits is
> retained and tracked internally in the driver, but never exposed
> to userspace.
> 
> Signed-off-by: Michal Januszewski <spock@gentoo.org>
> Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
> Cc: Ville Syrjälä <syrjala@sci.fi>
> Cc: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>
> ---

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>


 	
----------------------------------------------------------------------
Internetowe dowcipy na 1 kwietnia! Sprawdz! ;) 
http://link.interia.pl/f20f4

