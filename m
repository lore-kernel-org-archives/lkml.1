Return-Path: <linux-kernel-owner+w=401wt.eu-S1760366AbYD0LQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760366AbYD0LQe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 07:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbYD0LQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 07:16:26 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:1225 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbYD0LQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 07:16:26 -0400
Date: Sun, 27 Apr 2008 13:16:23 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: viro@ZenIV.linux.org.uk, cooloney@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blackfin checksum annotations
Message-ID: <20080427111623.GA6754@osiris.boeblingen.de.ibm.com>
References: <20080427052226.GP5882@ZenIV.linux.org.uk> <20080426.222644.74393287.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426.222644.74393287.davem@davemloft.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 10:26:44PM -0700, David Miller wrote:
> From: Al Viro <viro@ZenIV.linux.org.uk>
> Date: Sun, 27 Apr 2008 06:22:26 +0100
> 
> > 
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> Since these are networking knobs and Al tends to test his
> changes, I'll apply this to the net-2.6 tree.

I don't think such arch specific patches should go in via net-2.6.
You did that for a very similar patch for s390 and it was subtly broken:

See:
f994aae1bd8e4813d59a2ed64d17585fe42d03fc
("[NET]: S390 checksum annotations and cleanups.")

and

afbc1e994ddcf3b6fe2dc928ee8dc31a5d0c3118
("[S390] Fix TCP/UDP pseudo header checksum computation.")
