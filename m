Return-Path: <linux-kernel-owner+w=401wt.eu-S1763432AbYBNOZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763432AbYBNOZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 09:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbYBNOYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 09:24:54 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:47083 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbYBNOYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 09:24:54 -0500
Date: Thu, 14 Feb 2008 09:24:39 -0500
From: Jeff Dike <jdike@addtoit.com>
To: "Ph. Marek" <philipp.marek@bmlv.gv.at>
Cc: user-mode-linux-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24.2 won't compile UML
Message-ID: <20080214142439.GA5901@c2.user-mode-linux.org>
References: <200802141213.09859.philipp.marek@bmlv.gv.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802141213.09859.philipp.marek@bmlv.gv.at>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 12:13:09PM +0100, Ph. Marek wrote:
>   make -C linux-2.6.24.2/ O=output_path/build ARCH=um bzImage

>   make[2]: *** No rule to make target `bzImage'.  Stop.

This seems pretty clear, no?

bzImage is a x86-ism.  Just leave it off, and you'll get linux and vmlinux.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
