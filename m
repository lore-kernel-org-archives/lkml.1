Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbZI0O7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbZI0O7n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 10:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbZI0O7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 10:59:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60160 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbZI0O7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 10:59:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Regression] 2.6.31-git: tty change broke resume from hibernation on MSI Wind U100
Date: Sun, 27 Sep 2009 17:00:38 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Alan Cox <alan@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>
References: <200909260038.22079.rjw@sisk.pl> <20090927124716.2fd8a1de@lxorguk.ukuu.org.uk>
In-Reply-To: <20090927124716.2fd8a1de@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909271700.38541.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 September 2009, Alan Cox wrote:
> On Sat, 26 Sep 2009 00:38:21 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Hi Alan,
> > 
> > As stated at http://bugzilla.kernel.org/show_bug.cgi?id=14229, your commit
> > b50989dc444599c8b21edc23536fc305f4e9b7d5
> > (tty: make the kref destructor occur asynchronously) appears to have broken
> > resume from hibernation on MSI Wind U100.
> > 
> > I verified that hibernation works correctly with this commit reverted.
> > 
> > I'm still not sure what the root cause of the problem is, though.
> 
> The root cause is that the patch to fix the console async/sync behaviour
> went into Andrews tree, back out of it and vanished.
> 
> It's a known bug, with a known confirmed fix. You may want to pick it up
> and submit it as there is no tty maintainer currently.

Thanks, I guess it's this one:
tty-fix-regression-caused-by-tty-make-the-kref-destructor-occur-asynchronously.patch ?
