Return-Path: <linux-kernel-owner+w=401wt.eu-S1755085AbYC2Sio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbYC2Sio (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 14:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYC2Sif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 14:38:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49746 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbYC2Sif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 14:38:35 -0400
Date: Sat, 29 Mar 2008 18:38:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, torvalds@linux-foundation.org,
       wei.zhang@freescale.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix the broken annotations in fsldma
Message-ID: <20080329183828.GD9785@ZenIV.linux.org.uk>
References: <E1JfRSU-0002xg-LA@ZenIV.linux.org.uk> <1206799322.12155.10.camel@vader.jdub.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206799322.12155.10.camel@vader.jdub.homelinux.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2008 at 09:02:02AM -0500, Josh Boyer wrote:
> On Sat, 2008-03-29 at 03:10 +0000, Al Viro wrote:
> > a) every bitwise declaration will give a unique type; use typedefs.
> > b) no need to bother with the stuff pointed to by iomem pointers, unless
> > it's accessed directly.  noderef will force us to use helpers anyway.

> Did you forget to do the s/u{32,64}/v{32,64}/ conversion for this
> struct, or am I just a moron?

See (b) above.
