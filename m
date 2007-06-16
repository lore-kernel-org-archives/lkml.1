Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbXFPQZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbXFPQZs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 12:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbXFPQZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 12:25:29 -0400
Received: from canuck.infradead.org ([209.217.80.40]:60861 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbXFPQZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 12:25:25 -0400
Date: Sat, 16 Jun 2007 09:26:53 -0700
From: Greg KH <greg@kroah.com>
To: Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and
	manipulation,pathname matching
Message-ID: <20070616162653.GC20990@kroah.com>
References: <20070514110607.549397248@suse.de> <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com> <20070615165054.GA11345@kroah.com> <200706170044.DJF02182.TtMPNGNS@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706170044.DJF02182.TtMPNGNS@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 12:44:08AM +0900, Tetsuo Handa wrote:
> Greg KH wrote:
> > A daemon using inotify can "instantly"[1] detect this and label the file
> > properly if it shows up.
> 
> > Same daemon can do the re-label.
> 
> Can the daemon using inotify access to all pathnames in all process's
> namespaces?

I don't see why not, do you?

> Are the namespace the daemon has and the namespace of pathnames
> notified via inotify always the same?

If they are in the same namespace, then yes, they will as far as I can
tell.  Do you think this is incorrect?

thanks,

greg k-h
