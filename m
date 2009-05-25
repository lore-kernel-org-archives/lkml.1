Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbZEYKuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbZEYKuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 06:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbZEYKug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 06:50:36 -0400
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:49835 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752816AbZEYKug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 06:50:36 -0400
Date: Mon, 25 May 2009 12:50:36 +0200
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Ron Yorston <rmy@tigress.co.uk>
Cc: tytso@thunk.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: zero out blocks of freed user data for operation a virtual
	machine environment
Message-ID: <20090525105036.GA27604@cip.informatik.uni-erlangen.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	Ron Yorston <rmy@tigress.co.uk>, tytso@thunk.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <20090524170045.GC24753@cip.informatik.uni-erlangen.de> <200905250748.n4P7mbQS024844@tiffany.internal.tigress.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905250748.n4P7mbQS024844@tiffany.internal.tigress.co.uk>
User-Agent: Mutt/1.5.15 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ron,

* Ron Yorston <rmy@tigress.co.uk> [090525 09:49]:
> I've written a tool to zero freed blocks in ext2/ext3 filesystems, as well
> as a (half-baked) kernel patch.  Details here:

>    http://intgat.tigress.co.uk/rmy/uml/sparsify.html

nice work! While talking about sparse files: Do you know if there is an
option for qcow2 to reclaim zeroed out blocks (like a sparse in
userland)? I hope that this functionality hits upstream. It could also
used to provide a secure file deletion.

        Thomas
