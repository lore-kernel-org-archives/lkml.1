Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbXGHN7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbXGHN7x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 09:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbXGHN7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 09:59:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42395 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbXGHN7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 09:59:32 -0400
Date: Sun, 8 Jul 2007 14:58:29 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Miklos Szeredi <miklos@szeredi.hu>, oliver@neukum.org, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
Subject: Re: malicious filesystems (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
Message-ID: <20070708135829.GF21668@ftp.linux.org.uk>
References: <E1I6MWb-0008Tq-00@dorka.pomaz.szeredi.hu> <20070705091801.GB3084@elf.ucw.cz> <E1I6NgZ-0000F6-00@dorka.pomaz.szeredi.hu> <20070705115400.GF3984@ucw.cz> <E1I6Q73-0000Xi-00@dorka.pomaz.szeredi.hu> <20070707121729.GC3111@elf.ucw.cz> <E1I7H6v-0006pf-00@dorka.pomaz.szeredi.hu> <20070707233315.GB3820@elf.ucw.cz> <E1I7R5c-0007q3-00@dorka.pomaz.szeredi.hu> <20070708123748.GB3866@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070708123748.GB3866@ucw.cz>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2007 at 12:37:48PM +0000, Pavel Machek wrote:
> I'm talking malicious _filesystems_ here, and yes, fuse is first of
> this kind. We want to handle unresponding NFS, but I believe handling
> malicious NFS server nicely is slightly out of scope.

If your variant doesn't handle compromised NFS server, your variant is
needs to be fixed...
