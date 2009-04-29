Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbZD2OsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbZD2OsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 10:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZD2Or5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 10:47:57 -0400
Received: from blaine.gmane.org ([80.91.229.8]:57927 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbZD2Or4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 10:47:56 -0400
To: Alan Stern 
	<public-stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@hugh.gmane.org>
Cc: Greg KH <public-greg-U8xfFu+wG4EAvxtiuMwx3w@hugh.gmane.org>,
       Kay Sievers <public-kay.sievers-tD+1rO4QERM@hugh.gmane.org>,
       USB list <public-linux-usb-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
       Kernel development list 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>
Subject: Re: usbutils 0.81 release
References: <20090427210059.GA12446@kroah.com>
	<Pine.LNX.4.44L0.0904271715470.17474-100000@netrider.rowland.org>
From: Benny Amorsen <benny+usenet@amorsen.dk>
Date: Wed, 29 Apr 2009 16:23:14 +0200
In-Reply-To: <Pine.LNX.4.44L0.0904271715470.17474-100000@netrider.rowland.org> (Alan Stern's message of "Mon\, 27 Apr 2009 17\:21\:43 -0400 \(EDT\)")
Message-ID: <m3ab5z35f1.fsf@ursa.amorsen.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Spam-Score: -6.4 (------)
X-Spam-Report: ALL_TRUSTED=-3.3, BAYES_00=-3.099
X-Spam-Report: ALL_TRUSTED=-3.3, BAYES_00=-3.099
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
writes:

> Sure they do.  If you've got an RPM-based system, and you want to
> install a package version that's more recent than the one bundled in
> your distribution (or if your distribution doesn't include the package
> at all), then you'd want to build your own RPM.

In that case you grab the source package from the distribution, install
it, bump the version number and add the tar file to the SOURCES
directory. (And then you remove the patches which were upstreamed in the
meantime).

It isn't as easy as rpmbuild -ta, but it gets everything placed in the
right location and it preserves the distro-specific patches.


/Benny


