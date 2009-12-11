Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbZLKRYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbZLKRYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 12:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755766AbZLKRYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 12:24:47 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:60364 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbZLKRYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 12:24:46 -0500
Message-ID: <d4690bfe19cee0dc8c5355a684fa7e09.squirrel@intranet.cs.nmsu.edu>
Date: Fri, 11 Dec 2009 10:24:52 -0700
Subject: Logitech G13 driver + user-space libraries available
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Linux" <linux-kernel@vger.kernel.org>,
       "Linux Input" <linux-input@vger.kernel.org>,
       "Linux USB" <linux-usb@vger.kernel.org>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a first look at the G13 driver I've been playing around with:
     git://g13.git.sourceforge.net/gitroot/g13/g13

I've been building the driver out-of-tree and this is my first (untested)
shot at moving it in-tree. There are still a number of things to do (and
clean up) in the driver but it is rather functional.

I'll test it later today and update the repo as necessary, but I thought
I'd throw it out there now.

Here's the repo for the support libraries:
     svn co https://g13.svn.sourceforge.net/svnroot/g13/trunk g13

The Gtk and Gtkmm libs are empty for now, but I have tested the g13 and
g13-cairo libs.

The g13 library uses udev for device discovery and exports many of the
sysfs attributes in a little bit friendlier API. See the 'utilities'
directory and 'examples/g13-draw-checkerboard' for examples of the API.

The g13-cairo library similarly provides an API that bridges the
framebuffer functions of the g13 library with cairo making it a little
more friendly to draw directly on the framebuffer. See
'examples/cairo/g13-cairo-helloworld' for an animated example drawing with
cairo to the g13 framebuffer.

Feedback, comments, critiques and flames are welcome.

---

Rick


