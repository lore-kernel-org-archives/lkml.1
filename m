Return-Path: <linux-kernel-owner+w=401wt.eu-S1764822AbYEUCI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764822AbYEUCI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 22:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757297AbYEUCIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 22:08:50 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:44782 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbYEUCIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 22:08:50 -0400
Date: Tue, 20 May 2008 21:58:37 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Tom Spink <tspink@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: UML fails to locate address space
Message-ID: <20080521015837.GA16212@c2.user-mode-linux.org>
References: <7b9198260805200659p6ed28403t9b0b0ea995f158d5@mail.gmail.com> <20080520161047.GA9598@c2.user-mode-linux.org> <7b9198260805200943x6fb15512o7ba35a40d006b215@mail.gmail.com> <20080520175624.GA10889@c2.user-mode-linux.org> <7b9198260805201101x5b0fabf8h4944a29c6a4cae96@mail.gmail.com> <20080520192436.GA12102@c2.user-mode-linux.org> <7b9198260805201242p1adf4651kb4c434d73884b6c1@mail.gmail.com> <20080520212735.GA13319@c2.user-mode-linux.org> <7b9198260805201503j333963c4ya19b84f16b31d0fd@mail.gmail.com> <7b9198260805201657m19e023a9kabb897acea0d57d4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b9198260805201657m19e023a9kabb897acea0d57d4@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 12:57:21AM +0100, Tom Spink wrote:
> Here's the new patch, with that size correction in.  Does this look okay?

Actually, since the search for the lowest valid page needs to be there
anyway, I think we should just always use it, and not bother with
/proc/sys/vm/mmap_min_addr at all.  Less code, and the new code is
more heavily exercised this way.

     	     	       	    Jeff

-- 
Work email - jdike at linux dot intel dot com
