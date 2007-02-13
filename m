Return-Path: <linux-kernel-owner+w=401wt.eu-S1751408AbXBMSEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbXBMSEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 13:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbXBMSEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 13:04:53 -0500
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:55049 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbXBMSEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 13:04:52 -0500
Date: Tue, 13 Feb 2007 19:04:56 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-kernel@vger.kernel.org
Message-ID: <20070213180456.GL8882@enneenne.com>
References: <20070213173805.GK8882@enneenne.com> <20070213174829.GA465@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213174829.GA465@flint.arm.linux.org.uk>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] pxafb: Add option to enable/disable the cursor
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 05:48:29PM +0000, Russell King wrote:
> 
> Maybe this should be a generic option?  Or maybe issue ESC [ 25 l
> to disable the cursor if you're wanting to turn it off from userspace.

This is useful if you have a full screen boot logo. How I can issue
ESC [ 25 l at boot time?

Without this patch the full screen boot logo is corrupted in the upper
left corner with a little box containing the blinking cursor.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
