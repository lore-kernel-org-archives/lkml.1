Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbXKYLYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbXKYLYc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 06:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbXKYLYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 06:24:25 -0500
Received: from zakalwe.fi ([80.83.5.154]:54724 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbXKYLYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 06:24:24 -0500
Date: Sun, 25 Nov 2007 13:24:22 +0200
From: Heikki Orsila <shdl@zakalwe.fi>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, kune@deine-taler.de, johannes@sipsolutions.net
Subject: Re: [RFC] Documentation about unaligned memory access
Message-ID: <20071125112422.GH7681@zakalwe.fi>
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net> <20071123114329.GG7681@zakalwe.fi> <Pine.LNX.4.64.0711251215380.5532@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711251215380.5532@anakin>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 25, 2007 at 12:16:08PM +0100, Geert Uytterhoeven wrote:
> > ISA		Need		Need
> > 		natural		alignment
> > 		alignment	by x
> > --------------------------------------------
> > m68k		No		2
> 
> `No' for >= 68020.
> `Yes' for < 68020.

My bad, yes..

mc68020+	No		No
(mc68000/010	No		2)	(not for Linux)

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
