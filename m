Return-Path: <linux-kernel-owner+w=401wt.eu-S1759974AbYEUKmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbYEUKmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 06:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932610AbYEUKmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 06:42:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:35330 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932855AbYEUKmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 06:42:01 -0400
Date: Wed, 21 May 2008 12:41:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to avoid data copies in a driver ?
Message-ID: <20080521104153.GC4948@ucw.cz>
References: <38b2ab8a0805141254i2437a0ccq130b914748f53db0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38b2ab8a0805141254i2437a0ccq130b914748f53db0@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-05-14 21:54:03, Francis Moreau wrote:
> Hello,
> 
> I'd like to optimize my driver, which receives data through a fifo and gives
> them to a user space application. In turns this application moves this data
> into a file.
> 
> To avoid several useless copies, I'd like the application to pass to the driver
> a  file descriptor (?) to  the driver and then the driver can directly move the
> received data to that file.
> 
> Could anybody give me some example of such scheme ?

man splice?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
