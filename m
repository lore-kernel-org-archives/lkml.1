Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbXDCQVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbXDCQVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 12:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbXDCQVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 12:21:08 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1356 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753541AbXDCQVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 12:21:05 -0400
Date: Tue, 3 Apr 2007 16:20:52 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Paul LeoNerd Evans <leonerd@leonerd.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] vt: Expose system-wide UTF-8 default setting via sysfs
Message-ID: <20070403162051.GB5266@ucw.cz>
References: <4611ACCD.5000305@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4611ACCD.5000305@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Create a variable, default_utf8, that defines the system-wide default UTF-8
> setting.  This variable can be altered via sysfs. If the variable is properly
> set, this should mimimize breakage of UTF-8 encoded consoles when doing a
> reset or echo -e '\033c' and of newly opened/allocated consoles.

HPA is right... this should be fixed in userland. Reset should reset a
console, and if you want utf-8, do \ec\ewhatever to get it.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
