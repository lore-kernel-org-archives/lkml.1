Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbZAHH63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbZAHH63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 02:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757270AbZAHH6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 02:58:11 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:40793 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224AbZAHH6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 02:58:09 -0500
Date: Thu, 8 Jan 2009 08:59:49 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Regression] Build failure in current mainline - firmware related
Message-ID: <20090108075949.GC14179@uranus.ravnborg.org>
References: <200901031247.14977.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901031247.14977.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2009 at 12:47:14PM +0100, Rafael J. Wysocki wrote:
> Hi,
> 
> I get the following error from 'make modules_install' on my test boxes:
> 
>   HOSTCC  firmware/ihex2fw                                                             
> /home/rafael/src/linux-2.6/firmware/ihex2fw.c:268: fatal error: opening dependency file firmware/.ihex2fw.d: Read-only file system                                            
> compilation terminated.                                                                
> make[3]: *** [firmware/ihex2fw] Error 1                                                
> make[2]: *** [_modinst_post] Error 2                                                   
> make[1]: *** [sub-make] Error 2                                                        
> make: *** [all] Error 2
> 
> where the configuration is that the kernel is compiled on a build box
> with 'make O=<destdir> -j5' and then <destdir> is mounted over NFS read-only by
> each test box (full path to this directory is the same on the build box and on
> the test boxes).  Then, I cd into <destdir>, run 'make modules_install' and get
> the error above.
> 
> 2.6.28 didn't have this problem.

Fix is in mainline now.

	Sam
