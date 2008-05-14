Return-Path: <linux-kernel-owner+w=401wt.eu-S1762147AbYENUDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762147AbYENUDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 16:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756169AbYENUDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 16:03:09 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:55706 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755850AbYENUDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 16:03:06 -0400
Date: Wed, 14 May 2008 16:02:50 -0400
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to avoid data copies in a driver ?
Message-ID: <20080514200250.GB7579@csclub.uwaterloo.ca>
References: <38b2ab8a0805141254i2437a0ccq130b914748f53db0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38b2ab8a0805141254i2437a0ccq130b914748f53db0@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 09:54:03PM +0200, Francis Moreau wrote:
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

If the application memory mapped the file, would it be able to simply
pass a pointer to that mapped file as part of the call to the driver and
the driver would place the data directly at the requested location which
would then be directly to the file?

-- 
Len Sorensen
