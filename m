Return-Path: <linux-kernel-owner+w=401wt.eu-S1751533AbXCDJWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbXCDJWA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 04:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbXCDJWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 04:22:00 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:41757 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751532AbXCDJV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 04:21:59 -0500
Date: Sun, 4 Mar 2007 10:21:55 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Mike Accetta <maccetta@laurelnetworks.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Someone please turn on the http protocol on git.kernel.org!
In-Reply-To: <45E8220D.9040905@laurelnetworks.com>
Message-ID: <Pine.LNX.4.62.0703041020450.15476@pademelon.sonytel.be>
References: <7TYYU-5L8-11@gated-at.bofh.it> <7U2zx-392-13@gated-at.bofh.it>
 <45E8220D.9040905@laurelnetworks.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007, Mike Accetta wrote:
> H. Peter Anvin wrote:
> > Timur Tabi wrote:
> > > I see we now have a dedicate machine for the git server.  That's great.
> > > How about turning on the http protocol so that those of use behind a
> > > firewall can clone trees?
> > 
> > > I get this:
> > > 
> > > $ git-clone http://git.kernel.org/pub/scm/git.git
> > > Initialized empty Git repository in /temp/git/.git/
> > > Cannot get remote repository information.
> > > Perhaps git-update-server-info needs to be run there?
> > 
> > Don't use the git server for that, please.  Use
> > http://www.kernel.org/pub/scm/... instead.
> 
> Another unfortunate stuck behind a firewall here.  When I try this it chugs
> along for a while seeming to work but eventually aborts:
> 
> % git clone
> http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linus
> ...
> walk 0964ce24d091a1d3dc7f667e1b107ab77d4325e6
> walk c264852726dde251a0c09ec22f61a9be8b0db68b
> walk 69903d6500c73af8329a5fba7153b0d50748981c
> walk b59a9504cb93db7fae31e60760725d48652a1fc3
> error: Couldn't get
> http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/refs/tags/v2.6.11
> for tags/v2.6.11
> The requested URL returned error: 404
> error: Could not interpret tags/v2.6.11 as something to pull

I see these from time to time too, when pulling through http. Using the `other'
www.kernel.org (try www1.kernel.org vs. www2.kernel.org) usually fixes the
problem. I guess the mirroring is not perfect.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
