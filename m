Return-Path: <linux-kernel-owner+w=401wt.eu-S1762267AbYD0MnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762267AbYD0MnG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 08:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbYD0Mmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 08:42:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43034 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbYD0Mmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 08:42:54 -0400
Date: Sun, 27 Apr 2008 13:42:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: David Miller <davem@davemloft.net>, cooloney@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blackfin checksum annotations
Message-ID: <20080427124247.GV5882@ZenIV.linux.org.uk>
References: <20080427052226.GP5882@ZenIV.linux.org.uk> <20080426.222644.74393287.davem@davemloft.net> <20080427111623.GA6754@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427111623.GA6754@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 01:16:23PM +0200, Heiko Carstens wrote:

> I don't think such arch specific patches should go in via net-2.6.
> You did that for a very similar patch for s390 and it was subtly broken:
> 
> See:
> f994aae1bd8e4813d59a2ed64d17585fe42d03fc
> ("[NET]: S390 checksum annotations and cleanups.")
> 
> and
> 
> afbc1e994ddcf3b6fe2dc928ee8dc31a5d0c3118
> ("[S390] Fix TCP/UDP pseudo header checksum computation.")

I remember, and AFAICT this one is safe - here everything stays within
C and type changes ought to be equivalent transformations.  Said that,
I do _NOT_ have hardware in question and it's completely untested at
runtime.

Al, who really couldn't care less which tree that goes through - up to
davem and blackfin maintainers; both are on Cc, so...
