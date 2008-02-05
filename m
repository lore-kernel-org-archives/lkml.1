Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbYBERCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbYBERCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 12:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYBERCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 12:02:38 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:35301 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbYBERCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 12:02:37 -0500
Date: Tue, 5 Feb 2008 12:02:34 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Jim Meyering <jim@meyering.net>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] uml: handle unusual results from find_tempdir.
Message-ID: <20080205170234.GB9694@c2.user-mode-linux.org>
References: <87d4rb8j6l.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d4rb8j6l.fsf@rho.meyering.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 05:25:06PM +0100, Jim Meyering wrote:
> 
> An alternative: make find_tempdir set tempdir to default_tempdir
> upon malloc failure.
> 
> * arch/um/os-Linux/mem.c (make_tempfile): Handle NULL tempdir.
> Don't let a long tempdir (e.g., via TMPDIR) provoke heap corruption.
> 
> Signed-off-by: Jim Meyering <meyering@redhat.com>

Thanks, I'll forward this on.

			Jeff

-- 
Work email - jdike at linux dot intel dot com
