Return-Path: <linux-kernel-owner+w=401wt.eu-S1763329AbXHCQzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763329AbXHCQzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 12:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbXHCQyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 12:54:54 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:4026 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956AbXHCQyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 12:54:53 -0400
Date: Fri, 3 Aug 2007 17:54:49 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Yinghai.Lu@Sun.COM, Daniel Ritz <daniel.ritz-ml@swissonline.ch>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: REGRESSION: serial_cs broken by 8250 changes
In-Reply-To: <20070802163547.39f41af1.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64N.0708031751490.28399@blysk.ds.pg.gda.pl>
References: <200708030106.33917.daniel.ritz-ml@swissonline.ch>
 <46B267BA.4030006@sun.com> <20070802163547.39f41af1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007, Andrew Morton wrote:

> > We could use that to prevent init code to be called after code is freed.
> 
> If we can omit a function call without breaking anything then we shouldn't
> have been calling that function at all ;)

 Well, we can always put a couple of otherwise unneeded calls here and 
there to make the compiler happy to enjoy its freedom to produce code and 
exercise the calling convention rules set by the ABI before the actual 
use. ;-)

  Maciej
