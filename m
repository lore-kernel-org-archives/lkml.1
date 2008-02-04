Return-Path: <linux-kernel-owner+w=401wt.eu-S1758058AbYBDWBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058AbYBDWBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 17:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbYBDWBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 17:01:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42788 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755247AbYBDWBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 17:01:30 -0500
Date: Mon, 4 Feb 2008 14:00:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: jmorris@namei.org, morgan@kernel.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       serue@us.ibm.com
Subject: Re: [PATCH] per-process securebits
Message-Id: <20080204140004.c2f82638.akpm@linux-foundation.org>
In-Reply-To: <20080204181721.GA8758@ucw.cz>
References: <47A2D439.9050704@kernel.org>
	<20080201002837.d84fc029.akpm@linux-foundation.org>
	<Xine.LNX.4.64.0802011941140.16283@us.intercode.com.au>
	<20080204181721.GA8758@ucw.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2008 18:17:22 +0000
Pavel Machek <pavel@ucw.cz> wrote:

> On Fri 2008-02-01 20:07:01, James Morris wrote:
> > On Fri, 1 Feb 2008, Andrew Morton wrote:
> > 
> > > Really?  I'd feel a lot more comfortable if yesterday's version 1 had led
> > > to a stream of comments from suitably-knowledgeable kernel developers which
> > > indicated that those developers had scrutinised this code from every
> > > conceivable angle and had declared themselves 100% happy with it.
> > 
> > FWIW, I've reviewed the patch in detail a couple of times, and don't see 
> > any issues with it that haven't already been raised by Serge.
> > 
> > You can add my reviewed-by.
> > 
> > I think it does need more eyes, and some time baking in -mm.  
> 
> I don't thing -mm baking helps here. People playing with -mm are not
> the ones trying to hack your box.
> 

That's for sure.  Whitebox testing and really really careful review
is our best shot with this stuff.
