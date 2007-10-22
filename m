Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbXJVPfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbXJVPfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 11:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbXJVPez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 11:34:55 -0400
Received: from [198.99.130.12] ([198.99.130.12]:56223 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbXJVPey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 11:34:54 -0400
Date: Mon, 22 Oct 2007 11:33:43 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Nix <nix@esperi.org.uk>, Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
       Ingo Molar <mingo@elte.hu>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in 2.6.23-final.
Message-ID: <20071022153343.GA7117@c2.user-mode-linux.org>
References: <20071022043746.GF2998@hacking> <20071022052214.GY8181@ftp.linux.org.uk> <20071022061245.GG2998@hacking> <87d4v7fy5i.fsf@hades.wkstn.nix> <20071022065202.GI2998@hacking> <20071022065943.GC10864@uranus.ravnborg.org> <20071022074823.GJ2998@hacking> <20071022113600.GA8181@ftp.linux.org.uk> <20071022122504.GL2998@hacking> <20071022124322.GB8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022124322.GB8181@ftp.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 01:43:22PM +0100, Al Viro wrote:
> FWIW, I would simply kill the damn fastcall thing - right now the only
> user is uml/i386; everything else either has it #defined to nothing or
> (as i386 does) passes -mregparm=3 while having fastcall expand to
> __attribute__((regparm(3))) - i.e. has all functions fastcall.
> 
> Do we really need it on uml/i386 enough to keep bothering with that mess?

No, there was only that instance in linkage.h and I just got rid of
it.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
