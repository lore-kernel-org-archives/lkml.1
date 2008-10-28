Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbYJ1Tak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbYJ1Tak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 15:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbYJ1Taa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 15:30:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43225 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbYJ1Taa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 15:30:30 -0400
Date: Tue, 28 Oct 2008 20:32:04 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] w35und: plug memory leak in wbsoft_tx()
Message-ID: <20081028193204.GI16452@elf.ucw.cz>
References: <Pine.LNX.4.64.0810280014140.9821@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810280014140.9821@melkki.cs.Helsinki.FI>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-10-28 00:14:38, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> There's no reason to duplicate the skb in wbsoft_tx() and leak GFP_ATOMIC
> memory as the contents are copied to ->TxBuffer in MdxTx() anyway before
> MLMESendFrame() returns.

Acked-by: Pavel Machek <pavel@suse.cz>

...but I guess I should test the this after it hits the mainline...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
