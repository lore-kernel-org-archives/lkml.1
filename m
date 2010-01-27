Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529Ab0A0MaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab0A0MaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 07:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276Ab0A0MaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 07:30:23 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:35099 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab0A0MaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 07:30:22 -0500
Date: Wed, 27 Jan 2010 13:30:20 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: Dan Carpenter <error27@gmail.com>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: bug list: assigning negative values to unsigned variables
In-Reply-To: <1264590586.9749.2.camel@localhost>
Message-ID: <Pine.LNX.4.64.1001271329460.20256@ask.diku.dk>
References: <20100127104011.GA24796@bicker>  <Pine.LNX.4.64.1001271155430.20256@ask.diku.dk>
 <1264590586.9749.2.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010, Bernd Petrovitsch wrote:

> On Mit, 2010-01-27 at 11:57 +0100, Julia Lawall wrote:
> > On Wed, 27 Jan 2010, Dan Carpenter wrote:
> > 
> > > Fixing the places which assign negative values to unsigned variables is a good janitor task.
> > 
> > I had the impression that assignment to -1 was done sometimes as a 
> > portable way to initialize the variable to 0xffff (for any number of f's).  
> > So perhaps it is not so trivial to fix.
> Any particular reason that ~0U, ~0UL, and ~0ULL shouldn't do the same
> (without relying on conversion from signed to unsigned)?

Then the constant specifies the type?

julia
