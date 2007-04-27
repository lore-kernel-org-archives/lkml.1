Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbXD0TJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbXD0TJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757109AbXD0TJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 15:09:34 -0400
Received: from ns2.suse.de ([195.135.220.15]:35955 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757105AbXD0TJa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 15:09:30 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: Re: Back to the future.
Date: Fri, 27 Apr 2007 21:07:28 +0200
User-Agent: KMail/1.9.1
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704271150.55701.oliver@neukum.org> <Pine.LNX.4.64.0704271303260.925@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0704271303260.925@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704272107.28565.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 27. April 2007 12:12 schrieb Pekka J Enberg:
> I am talking about snapshot_system() here. It's not given that the 
> filesystems need to be read-only (you can snapshot them too). The benefit 
> here is that you can do whatever you want with the snapshot (encrypt, 
> compress, send over the network)  and have a clean well-defined interface 
> in the kernel. In addition, aborting the snapshot is simpler, simply 
> munmap() the snapshot.

But is that worth the trade off?

> The problem with writing in the kernel is obvious: we need to add new code 
> to the kernel for compression, encryption, and userspace interaction 
> (graphical progress bar) that are important for user experience.

The kernel can already do compression and encryption.

	Regards
		Oliver
