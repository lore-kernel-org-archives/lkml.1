Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbYIXDxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbYIXDxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 23:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYIXDxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 23:53:03 -0400
Received: from 1wt.eu ([62.212.114.60]:4453 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbYIXDxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 23:53:02 -0400
Date: Wed, 24 Sep 2008 05:52:22 +0200
From: Willy Tarreau <w@1wt.eu>
To: Alain Knaff <alain@knaff.lu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [update5] [PATCH] init: bzip2 or lzma -compressed kernels and initrds
Message-ID: <20080924035222.GA6457@1wt.eu>
References: <48C99F29.2030007@zytor.com> <48C9A6C0.4070802@knaff.lu> <48C9A80D.1010703@zytor.com> <48D73858.3070900@knaff.lu> <48D7C304.4020709@zytor.com> <48D7C48F.8010907@knaff.lu> <48D93E68.6040701@zytor.com> <48D9471E.9090108@knaff.lu> <48D95A8F.10705@zytor.com> <48D95ECC.9010107@knaff.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D95ECC.9010107@knaff.lu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 11:25:32PM +0200, Alain Knaff wrote:
> H. Peter Anvin wrote:
> > More failures...
> > 
> > /bin/sh: scripts/bin_size: No such file or directory
> 
> Could be a permission issue. Did you try to chmod 755 scripts/bin_size ?
> Hmmm, diff does indeed not encode permissions, how should such cases be
> usually handled?

either you find a way to chmod +x from a makefile (but this is a bit tricky)
or better, you call it with $(CONFIG_SHELL) :

   $(CONFIG_SHELL) scripts/bin_size

Some other commands in the makefiles are already handled this way.

Willy

