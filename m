Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbYFGBJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbYFGBJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758689AbYFGBGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:06:36 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:50658 "EHLO
	madrid.flash.tv.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758633AbYFGBGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:06:35 -0400
X-Greylist: delayed 668 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jun 2008 21:06:34 EDT
Date: Fri, 6 Jun 2008 21:52:27 -0300
From: Rog?rio Brito <rbrito@ime.usp.br>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc
Message-ID: <20080607005227.GA1739@ime.usp.br>
References: <20080601193000.GA3056@ime.usp.br> <20080606162324.GB635@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080606162324.GB635@tuxdriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of all, thanks John for taking the time to reply to my
message.

On Jun 06 2008, John W. Linville wrote:
> On Sun, Jun 01, 2008 at 04:30:01PM -0300, Rogério Brito wrote:
> > I have an iBook G3 600MHz combo (late 2001 model, powerpc) with a USB
> > wireless card rt2x00 that doesn't work.
> > 
> > I just compiled a fresh 2.6.26-rc4 kernel and it can't get a lease from
> > the access point, even though it is able to see the access point.
> > 
> > The userland here is Debian unstable (sid) and I can perform some of the
> > steps in the direction of configuring the interface. For instance, the
> > following works (I am using wep as the encryption system with other systems
> > running under Linux, but, unfortunately, EVEN disabling encryption for the
> > sake of the tests doesn't help here):
(...)
> > (Here, it is unable to grab an IP addess from the access point)
> 
> You should set the key _before_ setting the essid.

Thanks, but that unfortunately doesn't seem to help. :-(

I have taken dmesg "snapshots" of my system together with many other
information regarding how it is configured and I put it at my
homepage, at <http://www.ime.usp.br/debug/>.

>From what I am seeing, it looks like the bug mentioned in
<http://bugzilla.kernel.org/show_bug.cgi?id=9388>, but I don't get the
stack trace that is present there and I'm just trying to use WEP
instead of WPA or anything fancier.

Thanks for all the help and please let me know if further information
can be helpful for debugging this situation.


Thanks again, Rogerio Brito
