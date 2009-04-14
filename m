Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbZDNONj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbZDNONj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbZDNON3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:13:29 -0400
Received: from trinity.fluff.org ([89.16.178.74]:43152 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262AbZDNON2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:13:28 -0400
Date: Tue, 14 Apr 2009 15:13:26 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Mark Brown <broonie@sirena.org.uk>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH] i2c: Fix warnings from I2C_BOARD_INFO()
Message-ID: <20090414141326.GQ19997@trinity.fluff.org>
References: <1239716822-29143-1-git-send-email-ben-linux@fluff.org> <20090414141138.GK12678@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414141138.GK12678@sirena.org.uk>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 03:11:38PM +0100, Mark Brown wrote:
> On Tue, Apr 14, 2009 at 02:47:02PM +0100, Ben Dooks wrote:
> > The first argument for this macro is a string, and
> > thus having (arg) in the macro is causing gcc 4.2.4
> > to produce warnings about strings of the form ("str").
> 
> Ben Hutchings submitted a patch for this recently which Jean merged.

Yes, I didn't mean to submit this one, messed up git-format-patch for
the fs/super.c patch I wanted to send.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

