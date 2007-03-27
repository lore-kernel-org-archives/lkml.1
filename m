Return-Path: <linux-kernel-owner+w=401wt.eu-S1752684AbXC0Vhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbXC0Vhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 17:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932418AbXC0Vhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 17:37:38 -0400
Received: from lazybastard.de ([212.112.238.170]:35552 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbXC0Vhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 17:37:37 -0400
Date: Tue, 27 Mar 2007 23:33:40 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] add file position info to proc
Message-ID: <20070327213339.GG27290@lazybastard.org>
References: <E1HVELJ-0006ed-00@dorka.pomaz.szeredi.hu> <20070327212419.GA5817@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070327212419.GA5817@ucw.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 March 2007 21:24:20 +0000, Pavel Machek wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > This patch adds support for finding out the current file position,
> > open flags and possibly other info in the future.
> > 
> > These new entries are added:
> > 
> >   /proc/PID/fdinfo/FD
> >   /proc/PID/task/TID/fdinfo/FD
> > 
> > For each fd the information is provided in the following format:
> > 
> > pos:	1234
> > flags:	0100002
> 
> Octal? Maybe we should use more traditional hex here? Or even list
> flags by name?

The flags are defined in octal.  Whether that choice makes sense or
should be rethought is a different question.  I would definitely prefer
hex.

Jörn

-- 
You ain't got no problem, Jules. I'm on the motherfucker. Go back in
there, chill them niggers out and wait for the Wolf, who should be
coming directly.
-- Marsellus Wallace
