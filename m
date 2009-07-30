Return-Path: <linux-kernel-owner+w=401wt.eu-S1752714AbZG3ULy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbZG3ULy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 16:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbZG3ULx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 16:11:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40011 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752693AbZG3ULx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 16:11:53 -0400
Date: Thu, 30 Jul 2009 21:12:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jonathan Reed <jdreed@MIT.EDU>
Cc: Pavel Machek <pavel@ucw.cz>, Geoffrey Thomas <geofft@MIT.EDU>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Return ENOEXEC, not ENOENT, if a binary's or script's
 interpreter doesn't exist.
Message-ID: <20090730211256.31be54e6@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.2.00.0907301259170.5785@infinite-loop.mit.edu>
References: <alpine.DEB.2.00.0907301259170.5785@infinite-loop.mit.edu>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> They then go and look at /usr/bin/foo, find that it exists, and are 
> extremely confused.

-ENOEXEC is just as confusing. It is executable, it will match
(cmp/md5sum etc) with one on another box etc.

> More advanced users might at that point try and run "ldd" on the binary 
> (which will also fail, thanks to a missing interpreter).

So fix ldd ?
