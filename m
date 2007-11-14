Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbXKNO65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbXKNO65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbXKNO6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:58:49 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:48696 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbXKNO6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:58:49 -0500
Date: Wed, 14 Nov 2007 07:58:47 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Meyer <thomas@m3y3r.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: v2.6.24-rc2-409-g9418d5d: attempt to access beyond end of device
Message-ID: <20071114145847.GT17785@parisc-linux.org>
References: <4739F112.5060604@m3y3r.de> <473A10C2.6040102@m3y3r.de> <20071114145314.GA4537@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114145314.GA4537@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 03:53:15PM +0100, Ingo Molnar wrote:
> > By the way: Reverting commit 6f5391c283d7fdcf24bf40786ea79061919d1e1d 
> > makes the same cd medium readable again on v2.6.24-rc2-409-g9418d5d.
> 
> nice - that commit should then be reverted.

We're investigating; see bugzilla 9370.  Waiting on confirmation of
usage of ide-scsi.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
