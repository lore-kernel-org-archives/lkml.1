Return-Path: <linux-kernel-owner+w=401wt.eu-S1751654AbZL1HLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbZL1HLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 02:11:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbZL1HLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 02:11:03 -0500
Received: from www84.your-server.de ([213.133.104.84]:44559 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbZL1HLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 02:11:00 -0500
Subject: Re: [PATCH] [3/6] kfifo: Sanitize *_user error handling
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <20091227233405.GA2399@basil.fritz.box>
References: <200912271003.631128760@firstfloor.org>
	 <20091227210313.A8E7BB17C3@basil.firstfloor.org>
	 <1261949880.25298.21.camel@wall-e>  <20091227233405.GA2399@basil.fritz.box>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 28 Dec 2009 08:10:56 +0100
Message-ID: <1261984256.31031.21.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 28.12.2009, 00:34 +0100 schrieb Andi Kleen:
> > I don't like this idea. kfifo_from_user and kfifo_to_user should have
> > the same semantics as copy_from_user and copy_to_user. 
> 
> Maybe they should have, but the big difference is that the source
> FIFO might not have enough data. And both conditions need
> to be reported, but not mixed together.
> 
> The actual reporting of the unused length is not
> too useful anyways. It's only used very rarely for real
> c*u(), and these cases are usually misdesigned interfaces.
> 
> > > I didn't fully adapt the weird "record" variants, those seem 
> > > to be unused anyways and were rather messy (should they be just removed?)
> > > 
> > 
> > Believe it or not, it will be used in future. 
> 
> Normally in Linux code is only added when it's actually used.
> Otherwise it'll bitrot anyways.
> 

I know a lot of places and structures inside the kernel where it is not
this case. 

Stefani


