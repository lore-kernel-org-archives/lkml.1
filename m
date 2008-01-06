Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969AbYAFFE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbYAFFE7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 00:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbYAFFEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 00:04:52 -0500
Received: from [212.12.190.170] ([212.12.190.170]:53549 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750729AbYAFFEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 00:04:50 -0500
From: Al Boldi <a1426z@gawab.com>
To: Sam Ravnborg <sam@ravnborg.org>, Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage support
Date: Sun, 6 Jan 2008 08:03:27 +0300
User-Agent: KMail/1.5
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
References: <200801051546.SAA08947@raad.intranet> <20080105210330.GC22232@does.not.exist> <20080105210940.GA10302@uranus.ravnborg.org>
In-Reply-To: <20080105210940.GA10302@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200801060803.27101.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Sat, Jan 05, 2008 at 11:03:30PM +0200, Adrian Bunk wrote:
> > For kconfig users, "select" is _much_ better than sending them through
> > different menus.
>
> Only if used within the current limitations of Kconfig.
> And that requires you to use select only to select symbols with
> no dependencies.
>
> In this case we do not know if BLOCK is enabled or not.

Good point!  How about we solve it like this:

  	menuconfig USB_STORAGE
  	tristate "USB Mass Storage support"
-	depends on USB && SCSI
+	depends on USB && BLOCK
+	select SCSI


Thanks!

--
Al

