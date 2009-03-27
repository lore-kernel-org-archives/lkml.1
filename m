Return-Path: <linux-kernel-owner+w=401wt.eu-S1759715AbZC0Q3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715AbZC0Q3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 12:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759549AbZC0Q2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 12:28:55 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38138 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759537AbZC0Q2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 12:28:54 -0400
Date: Fri, 27 Mar 2009 16:28:41 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327162841.GA26860@srcf.ucam.org>
References: <20090327032301.GN6239@mit.edu> <20090327034705.GA16888@srcf.ucam.org> <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk> <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090327161553.31436545@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 04:15:53PM +0000, Alan Cox wrote:

> To be honest I don't see your problem. Surely well designed desktop
> applications are already all using nice error handling, out of space and
> fsync aware interfaces in the gnome library that do all the work for them
> - "so they don't have to check for errors".

The context was situations like errors on close() not occuring unless 
you've fsync()ed first. I don't think that error case is sufficiently 
common to warrant the cost of an fsync() on every single close, 
especially since doing so would cripple any application that ever tried 
to run on ext3.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
