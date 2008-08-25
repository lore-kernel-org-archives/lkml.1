Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbYHYBn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbYHYBn0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 21:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbYHYBnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 21:43:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39794 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbYHYBnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 21:43:16 -0400
Date: Mon, 25 Aug 2008 02:43:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Roland Dreier <rdreier@cisco.com>
Cc: David Vrabel <david.vrabel@csr.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>, torvalds@linux-foundation.org
Subject: Re: [patch] Add helper macros for little-endian bitfields
Message-ID: <20080825014311.GS28946@ZenIV.linux.org.uk>
References: <48AD6AF0.3050504@csr.com> <48AD6B93.7020702@csr.com> <adaprnxnac8.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaprnxnac8.fsf@cisco.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 06:37:43PM -0700, Roland Dreier wrote:
>  > + * NOTE: When using multibyte bitfields, you need to convert the data
>  > + *       from Little Endian to CPU before you can access the bitfield
>  > + *       (to make it simpler):

NOTE: When tempted to use multibyte bitfields on fixed-layout data, you
need to look in the mirror, ask yourself "what will they do to me during
code review for that?", shudder and decide that some temptations are
just not worth the pain.

IOW, don't do it.
