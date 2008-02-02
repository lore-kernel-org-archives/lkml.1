Return-Path: <linux-kernel-owner+w=401wt.eu-S933046AbYBBSYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046AbYBBSYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 13:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbYBBSYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 13:24:05 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4523 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751503AbYBBSYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 13:24:04 -0500
Date: Sat, 2 Feb 2008 18:23:52 +0000
From: Pavel Machek <pavel@ucw.cz>
To: pierre.peiffer@bull.net
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 2.6.24-rc8-mm1 00/15] IPC: code rewrite + new functionalities
Message-ID: <20080202182351.GC4456@ucw.cz>
References: <20080129160229.612172683@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129160229.612172683@bull.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> * Patches 9 to 15 propose to add some functionalities, and thus are
> submitted here for RFC, about both the interest and their implementation.
> These functionalities are:
>     - Two new control-commands:
> 	. IPC_SETID: to change an IPC's id.
> 	. IPC_SETALL: behaves as IPC_SET, except that it also sets all time
> 	  and pid values)
>     - add a /proc/<pid>/semundo file to read and write the undo values of
> some semaphores for a given process.
> 
> 	As the namespaces and the "containers" are being integrated in the
> kernel, these functionalities may be a first step to implement  the
> checkpoint/restart of an application: in fact the existing API does not allow
> to specify or to change an ID when creating an IPC, when restarting an
> application, and the times/pids values of each IPCs are also altered. May be
> someone may find another interest about this ?
> 
> So again, comments are welcome.

Checkpoint/restart is nice, but... sysV ipc is broken by design, do we
really want to extend it?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
