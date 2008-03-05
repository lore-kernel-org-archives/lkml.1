Return-Path: <linux-kernel-owner+w=401wt.eu-S1759166AbYCEVCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166AbYCEVCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbYCEVCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:02:10 -0500
Received: from ns1.suse.de ([195.135.220.2]:60664 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841AbYCEVCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:02:09 -0500
Date: Wed, 5 Mar 2008 22:02:07 +0100 (CET)
From: Michael Matz <matz@suse.de>
To: Jan Hubicka <hubicka@ucw.cz>
Cc: Joe Buck <Joe.Buck@synopsys.COM>, Aurelien Jarno <aurelien@aurel32.net>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: Linux doesn't follow x86/x86-64 ABI wrt direction flag
In-Reply-To: <20080305204945.GB14011@atrey.karlin.mff.cuni.cz>
Message-ID: <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de>
References: <20080305153020.GA24631@volta.aurel32.net> <47CEC3AA.6080709@zytor.com>
 <20080305195834.GA17267@synopsys.com> <20080305202319.GA17053@volta.aurel32.net>
 <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de> <20080305204234.GB17267@synopsys.com>
 <20080305204945.GB14011@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 5 Mar 2008, Jan Hubicka wrote:

> Kernels almost never follow ABI used by applications to last detail. 

But we aren't talking about the ABI the kernel uses internally, but about 
what is exposed to user-space via signal handlers.  _That_ part needs to 
be followed, and if it isn't it's a serious problem we somehow have to 
hack around.

> Linux kernel is disabling red zone and use kernel code model, yet the 
> ABI is not going to be adjusted for that.
> 
> This is resonably easy to fix on kernel side in signal handling, or by
> removing std usage completely

That is true.  But it requires updating the kernel to a fixed one if you 
want to run your programs compiled by 4.3 :-/  Not something we'd like to 
demand.


Ciao,
Michael.
