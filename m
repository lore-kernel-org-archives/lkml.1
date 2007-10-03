Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbXJCKvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbXJCKvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 06:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbXJCKv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 06:51:29 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2143 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754452AbXJCKv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 06:51:28 -0400
Date: Wed, 3 Oct 2007 10:51:15 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       marc.smith@esmail.mcc.edu
Subject: Re: VM/VFS bug with large amount of memory and file systems?
Message-ID: <20071003105115.GA6300@ucw.cz>
References: <C2A8AED2-363F-4131-863C-918465C1F4E1@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C2A8AED2-363F-4131-863C-918465C1F4E1@cam.ac.uk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2007-09-15 08:27:23, Anton Altaparmakov wrote:
> Hi,
> 
> Mark Smith reported a OOM condition when he copies a 
> large (46GiB)  file from an NTFS partition (using the 
> stock kernel driver) to /dev/ null (or to a file on 
> ext3, same result).
> 
> The machine this runs on has an i386 kernel with 12GiB 
> RAM (yes this  is not a typo it is 12GiB!).

Yes, that's known broken. 32bit machines with to much memory just do
not work properly.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
