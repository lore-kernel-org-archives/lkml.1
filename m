Return-Path: <linux-kernel-owner+w=401wt.eu-S1752321AbXJUNS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbXJUNS2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 09:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbXJUNSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 09:18:22 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:48290 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbXJUNSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 09:18:21 -0400
Date: Sun, 21 Oct 2007 09:08:48 -0400
From: Jeff Dike <jdike@addtoit.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Nix <nix@esperi.org.uk>, Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in 2.6.23-final.
Message-ID: <20071021130848.GA4621@c2.user-mode-linux.org>
References: <200710111754.46854.rob@landley.net> <200710200252.37919.p.giarrusso@gmail.com> <87y7dyhv2u.fsf@hades.wkstn.nix> <20071021114854.GF2455@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071021114854.GF2455@hacking>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2007 at 07:48:54PM +0800, WANG Cong wrote:
> UML still doesn't build on 2.6.23-git16.
> 
> Gcc threw out many errors, I put them in the web:
> 	http://wangcong.org/down/errors.txt

Looks like either you need to run mrproper and try again, or maybe
fallout from the x86 merge, with include/asm-um/arch pointing to
include/asm-i386 instead of include/asm-x86.  Although I though Al had
UML building in the presence of the x86 merge.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
