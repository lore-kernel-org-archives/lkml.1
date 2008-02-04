Return-Path: <linux-kernel-owner+w=401wt.eu-S1757072AbYBDTvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072AbYBDTvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 14:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbYBDTvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 14:51:35 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38691 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755425AbYBDTvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 14:51:35 -0500
Date: Mon, 4 Feb 2008 20:51:50 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Benjamin Thery <benjamin.thery@bull.net>
Cc: pierre.peiffer@bull.net, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24-rc8-mm1 00/15] IPC: code rewrite + new
	functionalities
Message-ID: <20080204195150.GA4915@elf.ucw.cz>
References: <20080129160229.612172683@bull.net> <20080202182351.GC4456@ucw.cz> <47A732E2.1000504@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A732E2.1000504@bull.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>>> 	As the namespaces and the "containers" are being integrated in the
>>> kernel, these functionalities may be a first step to implement  the
>>> checkpoint/restart of an application: in fact the existing API does not allow
>>> to specify or to change an ID when creating an IPC, when restarting an
>>> application, and the times/pids values of each IPCs are also altered. May be
>>> someone may find another interest about this ?
>>>
>>> So again, comments are welcome.
>>
>> Checkpoint/restart is nice, but... sysV ipc is broken by design, do we
>> really want to extend it?

>
> For my personal culture, what do you mean by "broken by design"?


       int shmget(key_t key, size_t size, int shmflg);

....so how do you produce key in a way that is guaranteed not to
interfere with other uses?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
