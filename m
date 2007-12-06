Return-Path: <linux-kernel-owner+w=401wt.eu-S1759665AbXLRPge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759665AbXLRPge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 10:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757430AbXLRPgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 10:36:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1200 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757064AbXLRPgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 10:36:24 -0500
Date: Thu, 6 Dec 2007 15:29:07 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
Message-ID: <20071206152906.GA3974@ucw.cz>
References: <20071216080441.435456586@I-love.SAKURA.ne.jp> <20071216080628.061470932@I-love.SAKURA.ne.jp> <200712161944.HEI26071.MOtOFLVHFSQFOJ@I-love.SAKURA.ne.jp> <200712161956.BJE32406.FOOHtQJLMFOSVF@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712161956.BJE32406.FOOHtQJLMFOSVF@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Why not use SELinux?
> 
>  Because SELinux doesn't guarantee filename and its attribute.
>  The purpose of this filesystem is to ensure filename and its attribute
>  (e.g. /dev/null is guaranteed to be a character device file
>  with major=1 and minor=3).

Why not improve selinux to be able to assign label of new file based
on directory label and name?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
