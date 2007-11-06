Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbXKFXe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbXKFXe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 18:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbXKFXeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 18:34:50 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53949 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbXKFXet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 18:34:49 -0500
Date: Tue, 6 Nov 2007 23:34:48 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix writing to unintended memory in pkt_generic_packet(); drivers/block/pktcdvd.c
Message-ID: <20071106233448.GM8181@ftp.linux.org.uk>
References: <4730EE00.8040809@tiscali.nl> <20071106225012.GK8181@ftp.linux.org.uk> <4730F568.3080901@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4730F568.3080901@tiscali.nl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 12:14:48AM +0100, Roel Kluin wrote:
> Al Viro wrote:
> > On Tue, Nov 06, 2007 at 11:43:12PM +0100, Roel Kluin wrote:
> >> CDROM_PACKET_SIZE is added as an offset to the pointer to unsigned char cmd[16].
> >> The adjusted pointer is then used as a destination address in a call to
> >> memset(). However, when CDROM_PACKET_SIZE is added to the pointer, it is
> >> automatically scaled by the size of cmd, which is 16. This results in the call
> >> to memset() writing to unintended memory.
> > 
> > What are you talking about?  rq->cmd is an array, not a pointer to array.
> > When it occurs as an argument of +, it decays to pointer to array element.
> 
> Ok, I misunderstood, but please...
> 
> > Please, learn C.
> 
> That's not a nice thing to say.

Excuse me, but if you want to write in C, you will have to learn the language.
Really.  Including the relationship between pointers and arrays.  No way
around it, it's really basic stuff.  Whether it's a nice thing to say or not,
it is true and I do not know more polite way to phrase that.
