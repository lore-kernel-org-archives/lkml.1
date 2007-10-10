Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbXJJTCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbXJJTCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 15:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbXJJTCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 15:02:35 -0400
Received: from fencepost.gnu.org ([140.186.70.10]:58627 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbXJJTCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 15:02:34 -0400
Subject: Re: idio{,ma}tic typos (was Re: +
	fix-vm_can_nonlinear-check-in-sys_remap_file_pages.patch added to -mm tree)
From: Pavel Roskin <proski@gnu.org>
To: Josh Triplett <josh@freedesktop.org>
Cc: Morten Welinder <mwelinder@gmail.com>, Alexey Dobriyan <adobriyan@sw.ru>,
       Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       davej@codemonkey.org.uk, Pierre Ossman <drzeus@drzeus.cx>,
       akpm@osdl.org, linux-sparse@vger.kernel.org
In-Reply-To: <470D1535.6030708@freedesktop.org>
References: <20071010104540.GA6366@localhost.sw.ru>
	 <118833cc0710100635x205503a2peb73d24384538afa@mail.gmail.com>
	 <470D1535.6030708@freedesktop.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 10 Oct 2007 15:02:27 -0400
Message-Id: <1192042947.29176.2.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-6.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-10 at 11:08 -0700, Josh Triplett wrote:

> Sparse has a notion of "integer constant expression" already, which it
> uses to validate expressions used for things like bitfield widths or
> array sizes.  I could easily have Sparse warn on any use of an integer
> constant expression as an operand of || or &&.  However, I can imagine
> that that might lead to some false positives when intentionally using
> an integer constant expression in a condition and expecting the
> compiler to optimize it out at compile time.

I can imagine 0 or 1 being used, maybe -1, but hardly anything else.
Maybe you could add the code printing the value and then get some
statics on the actual Linux kernel to see which values are common and
which are not?

-- 
Regards,
Pavel Roskin

