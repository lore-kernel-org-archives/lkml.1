Return-Path: <linux-kernel-owner+w=401wt.eu-S1760730AbZAHUSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760730AbZAHUSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759116AbZAHUSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:18:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53073 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759177AbZAHUSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:18:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [Regression] Build failure in current mainline - firmware related
Date: Thu, 8 Jan 2009 21:17:45 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>
References: <200901031247.14977.rjw@sisk.pl> <20090108075949.GC14179@uranus.ravnborg.org>
In-Reply-To: <20090108075949.GC14179@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901082117.46080.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 January 2009, Sam Ravnborg wrote:
> On Sat, Jan 03, 2009 at 12:47:14PM +0100, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > I get the following error from 'make modules_install' on my test boxes:
> > 
> >   HOSTCC  firmware/ihex2fw                                                             
> > /home/rafael/src/linux-2.6/firmware/ihex2fw.c:268: fatal error: opening dependency file firmware/.ihex2fw.d: Read-only file system                                            
> > compilation terminated.                                                                
> > make[3]: *** [firmware/ihex2fw] Error 1                                                
> > make[2]: *** [_modinst_post] Error 2                                                   
> > make[1]: *** [sub-make] Error 2                                                        
> > make: *** [all] Error 2
> > 
> > where the configuration is that the kernel is compiled on a build box
> > with 'make O=<destdir> -j5' and then <destdir> is mounted over NFS read-only by
> > each test box (full path to this directory is the same on the build box and on
> > the test boxes).  Then, I cd into <destdir>, run 'make modules_install' and get
> > the error above.
> > 
> > 2.6.28 didn't have this problem.
> 
> Fix is in mainline now.

I noticed, thanks a lot!

Rafael
