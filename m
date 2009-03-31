Return-Path: <linux-kernel-owner+w=401wt.eu-S1760536AbZCaT2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760536AbZCaT2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 15:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbZCaT1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 15:27:50 -0400
Received: from lazybastard.de ([212.112.238.170]:55782 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbZCaT1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 15:27:50 -0400
Date: Tue, 31 Mar 2009 20:45:17 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Mark Lord <lkml@rtr.ca>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090331184517.GA25879@logfs.org>
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <49CECC7B.70100@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49CECC7B.70100@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 March 2009 21:18:51 -0400, Jeff Garzik wrote:
> 
> Was the BSD soft-updates idea of FS data-before-metadata a good one? 
> Yes.  Obviously.
> 
> It is the cornerstone of every SANE journalling-esque database or 
> filesystem out there -- don't leave a window where your metadata is 
> inconsistent.  "Duh" :)

Your idea of 'consistent' seems a bit fuzzy.  Soft updates, afaiu, leave
plenty of windows and reasons to run fsck.  They only guarantee that all
those windows result in lost space - data allocations without any
references.  It certainly prevents the worst problems, but I would use a
different word for it. :)

Jörn

-- 
Don't worry about people stealing your ideas. If your ideas are any good,
you'll have to ram them down people's throats.
-- Howard Aiken quoted by Ken Iverson quoted by Jim Horning quoted by
   Raph Levien, 1979
