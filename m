Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509Ab0ARD6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab0ARD6j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 22:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324Ab0ARD6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 22:58:37 -0500
Received: from mail.perches.com ([173.55.12.10]:1248 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755311Ab0ARD6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 22:58:35 -0500
Subject: Re: [PATCH] S2io: two branches the same in wait_for_cmd_complete()
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: roel.kluin@gmail.com, netdev@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sivakumar.subramani@neterion.com,
       ram.vepa@neterion.com, santosh.rastapur@neterion.com,
       sreenivasa.honnur@neterion.com, anil.murthy@neterion.com
In-Reply-To: <20100117.191359.190417865.davem@davemloft.net>
References: <4B53284C.1090405@gmail.com>
	 <20100117.191359.190417865.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Jan 2010 19:58:32 -0800
Message-ID: <1263787112.26846.73.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-17 at 19:13 -0800, David Miller wrote:
> From: Roel Kluin <roel.kluin@gmail.com>
> Date: Sun, 17 Jan 2010 16:10:04 +0100
> > Regardless of the bit_state, the branches execute the same code.
> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > ---
> >  drivers/net/s2io.c |   13 +++----------
> >  1 files changed, 3 insertions(+), 10 deletions(-)
> > Maybe something else was intended?
> > this was introduced in commit 9fc93a41a1ad11
> If you know the guilty commit, at least do the author(s) of commit
> and/or the driver maintainer(s) the courtesy of CC:'ing them on
> patches like this.

One way to do that is to use:
$ ./scripts/get_maintainer.pl --git-blame <patch>


