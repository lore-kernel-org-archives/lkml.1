Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab0BKUvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:51:36 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60468 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089Ab0BKUvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:51:35 -0500
Date: Thu, 11 Feb 2010 21:51:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "J.H." <warthog9@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       lasse.collin@tukaani.org
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100211205129.GA26105@elf.ucw.cz>
References: <4B744E13.8040004@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B744E13.8040004@kernel.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Option 1)
> 
> Leave gz as the master, and migrate bz2 to xz.  This will happen in
> stages obviously. with bz2 ultimately being phased out.
> 
> 	Migration option 1)
> 
> 		All new content would be provided in .bz2 and .xz with
> 		an ultimate date set that the .bz2 files would stop
> 		being generated with new content.  This would leave all
> 		existing content alone and it would not be a migration
> 		of the current .bz2 files to xz

I believe this is cleanest. gzip has performance advantages, and old
files suddenly disappearing would be just weird.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
