Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbZKORCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbZKORCO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 12:02:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZKORCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 12:02:13 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35473 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752161AbZKORCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 12:02:13 -0500
Date: Sun, 15 Nov 2009 17:03:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: =?UTF-8?B?UHJ6ZW15c8WCYXcgUGF3ZcWCY3p5aw==?= 
	<przemyslaw@pawelczyk.it>
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: consolechars switches tty since 8b92e87 vt: add an event
 interface
Message-ID: <20091115170339.59528e49@lxorguk.ukuu.org.uk>
In-Reply-To: <40e92d5b0911150530y67878707yed776478a51a34c@mail.gmail.com>
References: <40e92d5b0911150530y67878707yed776478a51a34c@mail.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [ In Debian before the end of the S runlevel (boot) console-screen.sh
> is executed (it is not the last script though), where consolechars is
> used for loading console screen font for each tty. In my case it
> evaluates to:
> 
>     /usr/bin/consolechars --tty=/dev/ttyX -f lat0-sun16
> 
> Similarly consolechars is used in setupcon script invoked by
> console-setup (processed after console-screen.sh) to set a font chosen
> by user. ]
> 
> The problem is that since 8b92e87 running consolechars switches tty to
> the one provided with --tty option. Last commit I have tested,
> a9366e6, is still affected.

That is a suprise as the code shouldn't be changing the behaviour of any
application unless something happened to rely on the race it fixed. Even
then I wouldn't expect what you see.

What does an strace of that command look like so I can see what ioctls it
issues and in what order.

Alan
