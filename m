Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbYCXVlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbYCXVlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 17:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYCXVlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 17:41:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46700
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752437AbYCXVlI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 17:41:08 -0400
Date: Mon, 24 Mar 2008 14:41:07 -0700 (PDT)
Message-Id: <20080324.144107.235200795.davem@davemloft.net>
To: fhimpe@telenet.be
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-2.6] [TCP]: Must count fack_count also when skipping
From: David Miller <davem@davemloft.net>
In-Reply-To: <pan.2008.03.24.20.36.07@telenet.be>
References: <Pine.LNX.4.64.0803031525390.27064@kivilampi-30.cs.helsinki.fi>
	<Pine.LNX.4.64.0803031541230.28251@kivilampi-30.cs.helsinki.fi>
	<pan.2008.03.24.20.36.07@telenet.be>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederik Himpe <fhimpe@telenet.be>
Date: Mon, 24 Mar 2008 20:36:08 +0000 (UTC)

> On Mon, 03 Mar 2008 15:53:12 +0200, Ilpo Järvinen
> wrote:
> 
> > [PATCH net-2.6] [TCP]: Must count fack_count also when skipping
> > 
> > It makes fackets_out to grow too slowly compared with the real write
> > queue.
> > 
> > This shouldn't cause those BUG_TRAP(packets <= tp->packets_out) to
> > trigger but how knows how such inconsistent fackets_out affects here and
> > there around TCP when everything is nowadays assuming accurate
> > fackets_out. So lets see if this silences them all.
> > 
> > Reported by Guillaume Chazarain <guichaz@gmail.com>.
> 
> Will this patch be applied to 2.6.24 stable? I think I have been hit by 
> the same problem recently:

I'll push it to the -stable folks for their next release
since people are actively hitting it.
