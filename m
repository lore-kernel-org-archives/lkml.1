Return-Path: <linux-kernel-owner+w=401wt.eu-S1759919AbYBSTYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759919AbYBSTYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbYBSTYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:24:38 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:60205 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbYBSTYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:24:37 -0500
Date: Tue, 19 Feb 2008 20:24:47 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Karl Dahlke <eklhad@comcast.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Where to put adapters
Message-ID: <20080219192447.GB11948@uranus.ravnborg.org>
References: <20080119080148.eklhad@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080119080148.eklhad@comcast.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 08:01:48AM -0500, Karl Dahlke wrote:
> Now that notifiers are in, (yay!), people are going to start writing adapters
> for visually and motor impaired individuals.
> I suggest we place them in drivers/adapters in the source tree,
> and I suggest they put their virtual files in the directory /proc/adapters,
> which would be created via fs/proc/root.c as part of the /proc file system.

/proc is for processes (and was in the past used for all sort of crap).
So without knowing what an adapter is in this context /proc
seems to be a bad choice.

	Sam
