Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbYLOQaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbYLOQaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 11:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbYLOQaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 11:30:11 -0500
Received: from main.gmane.org ([80.91.229.2]:32971 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbYLOQaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 11:30:10 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitaram Chamarty <sitaramc@gmail.com>
Subject: Re: problem with git.kernel.org
Date: Mon, 15 Dec 2008 16:07:18 +0000 (UTC)
Organization: disorganised!
Message-ID: <gi5vbm$tts$1@ger.gmane.org>
References: <543076374@web.de> <49465862.9090400@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: atcmail.atc.tcs.co.in
User-Agent: slrn/0.9.9 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-12-15, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Chris, you should enable fetching over http by
> $ cd /pub/scm/linux/kernel/git/mason/btrfs-unstable-standalone.git
> $ cp -p hooks/post-update.sample hooks/post-update

I notice that the .git/hooks/post-update still calls it
"git-update-server-info".  Shouldn't that be "git
update-server-info"?

[my git is 1.6.0.2, but even on a checked out though not
compiled-and-installed 1.6.0.4 it is the same]

> Cloning a full kernel repo over http may be too unreliable, but cloning
> a smaller repo like the btrfs standalone repo should work acceptably
> over http.

Maybe git bundle can help.  Perhaps there can be some
documented way of creating a HTTP-downloadable bundle from
the current "master" in any web-accessible git to make
things really easy for first time downloaders, maybe updated
only once in a month or so.  Anyone having trouble doing a
clone would get this, fetch it in, set up remote/origin, and
then do a normal pull...

