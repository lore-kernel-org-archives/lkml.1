Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbXLBRJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbXLBRJf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 12:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbXLBRJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 12:09:27 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48181 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbXLBRJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 12:09:25 -0500
Date: Sun, 2 Dec 2007 09:07:55 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Mark Lord <lkml@rtr.ca>
Cc: dmitry.torokhov@gmail.com, rubini@vision.unipv.it,
       linux-input@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, jkosina@suse.cz,
       linux-usb@vger.kernel.org
Subject: Re: REGRESSION: 2.6.24:  false double-clicks from USB mouse
Message-ID: <20071202090755.342280f6@laptopd505.fenrus.org>
In-Reply-To: <4752E5AD.40905@rtr.ca>
References: <4752DB8C.50608@rtr.ca>
	<4752E432.10504@rtr.ca>
	<4752E5AD.40905@rtr.ca>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Dec 2007 12:04:45 -0500
Mark Lord <lkml@rtr.ca> wrote:

> Mark Lord wrote:
> > Mark Lord wrote:
> >> I've only just recently tried running 2.6.24 on my main machine.
> >> And it appears that I'll have to go back to 2.6.23,
> >> because the USB mouse is not working correctly.
> >>
> >> Single-clicking on things with 2.6.24 very frequently gives a 
> >> "double-click".
> >> This does not happen with 2.6.23.8.
> >>
> >> I wonder what broke it?
> >>
> >> I've grabbed mousedev.c from 2.6.23 and inserted that in place
> >> of the updated 2.6.24 source, but no change.  So it's not that
> >> file.
> > ...
> > 
> > Mmm.. reverting the entire drivers/hid directory to that from 2.6.23
> > seems to have fixed the problem, so we now know it's in there
> > somewhere.
> > 


just making sure.. this is while running an untainted kernel without
something like vmware loaded, right?


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
