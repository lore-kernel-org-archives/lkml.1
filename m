Return-Path: <linux-kernel-owner+w=401wt.eu-S1754370AbZGJMEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbZGJMEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbZGJMEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:04:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53235 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbZGJMEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:04:41 -0400
Date: Fri, 10 Jul 2009 01:19:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Christof Warlich <christof@warlich.name>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: "EXT3-fs error" after resume from s2ram
Message-ID: <20090709231915.GA1469@ucw.cz>
References: <4A4771FD.1020207@warlich.name> <4A480859.5010206@gmail.com> <4A48C799.2010102@warlich.name> <4A495C2D.1040706@gmail.com> <4A49A49C.10104@warlich.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A49A49C.10104@warlich.name>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-06-30 07:37:32, Christof Warlich wrote:
> No, really nothing else but these EXT3-fs error messages are printed to vt1,
> and as the disk is not accessible,  nothing can be found in  
> /var/log/kern.log either.
>
> With respect to libata and SCSI and on a normal system boot,  
> /var/log/kern.log just
> contains:
>
> SCSI subsystem initialized
> libata version 3.00 loaded.
>
> so nothing helpful either.  Do you want me to send an entire boot -  
> suspend cycle
> from /var/log/kern.log?

Try killall klogd before suspend/resume cycle?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
