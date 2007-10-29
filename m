Return-Path: <linux-kernel-owner+w=401wt.eu-S1753651AbXJ2VpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbXJ2VpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 17:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbXJ2Vox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 17:44:53 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:54196 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752267AbXJ2Vox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 17:44:53 -0400
Date: Mon, 29 Oct 2007 17:44:52 -0400
To: Pavel Machek <pavel@ucw.cz>
Cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
Message-ID: <20071029214452.GA27643@csclub.uwaterloo.ca>
References: <20071014190128.6e3cdb44@bree.surriel.com> <20071028180707.GA6111@ucw.cz> <20071029194820.GC27646@csclub.uwaterloo.ca> <20071029201911.GB3537@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029201911.GB3537@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 09:19:11PM +0100, Pavel Machek wrote:
> Tell it to your profesor ;-).

I don't have one.  I graduated 7 years ago.  I was just pointing holes
in the spec. :)

> Not neccessarily but yes, that would be nice, too.

If it doesn't it seems the compression feature is going to be rather
unpredictable and my optimization would be perfectly within spec and
make it pretty much useless.

> Yes. Typically for all zeros. It will be similar for
> highly-compressible data (pictures, timetables, ....)

That would make it tricky to say if you should ever skip compression due
to cpu load.  There is a chance cpu load would be better off by doing
the compression.

> root@amd:/data/tmp# time ( cat /dev/zero | head -c 100000000 > delme; sync )
> 0.04user 0.48system 6.52 (0m6.521s) elapsed 7.97%CPU
> root@amd:/data/tmp# time ( cat /dev/zero | head -c 100000000 > delme; sync )
> 0.05user 0.61system 6.33 (0m6.333s) elapsed 10.42%CPU
> root@amd:/data/tmp# time ( cat /dev/zero | head -c 100000000 | gzip - > delme; sync )
> 1.57user 0.32system 1.74 (0m1.749s) elapsed 100.00%CPU
> root@amd:/data/tmp# time ( cat /dev/zero | head -c 100000000 | gzip - > delme; sync )
> 1.61user 0.18system 1.65 (0m1.652s) elapsed 100.00%CPU

--
Len Sorensen
