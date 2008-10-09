Return-Path: <linux-kernel-owner+w=401wt.eu-S1758167AbYJIMEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167AbYJIMEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 08:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbYJIMD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 08:03:58 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41898 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753275AbYJIMD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 08:03:57 -0400
Date: Thu, 9 Oct 2008 14:03:33 +0200
From: Pavel Machek <pavel@suse.cz>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: linux-kernel@vger.kernel.org, lirc-list@lists.sourceforge.net
Subject: Re: [RFC PATCH 0/4] V3 - Implementation of IR support using the
	input subsystem
Message-ID: <20081009120333.GA1623@ucw.cz>
References: <20081006194032.15992.8393.stgit@terra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006194032.15992.8393.stgit@terra>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>  What should the IR API look like?  How are IR events mapped into
> keyboard events? Should they be mapped? Map them in the kernel or in
> user space? The maps are tiny, less than 1K per remote.  Sysfs can
> be used to load maps into the kernel driver. Make maps only for the
> common buttons and don't map unusual ones?

Map them in kernel, in analogy with normal keyboards.  
 
> How should multiple remotes be handled? Split them out into
> individual input devices, or group them onto a single IR device? I
> can implement either.

Individual input devices, I'd say... so that app can only listen for
'its' remote.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
