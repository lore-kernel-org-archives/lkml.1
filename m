Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbYELOOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbYELOOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 10:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbYELOOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 10:14:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:50736 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYELOOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 10:14:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Xo9QCSJExqmCVldh1ZprpOXCfaQ4NEKiDTw+A8oYhAcQuRm+Su+bex66AHBXPZGbRWR3moXT2KtRqDC4fMhXkW+nzcNC3/zzK3vO/Qb5lcE/pPJy4EMVay0UbIzWvYxBhdE+tSDcGaL1i2m8Pgk6I+8kD9YbyNWL7iKe4ynHh70=
Date: Mon, 12 May 2008 18:14:20 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pavel Machek <pavel@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: wakeup.lds.S - section ordering fix
Message-ID: <20080512141420.GA6913@cvg>
References: <20080511184638.GE6942@cvg> <20080512135343.GA1725@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080512135343.GA1725@elf.ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Pavel Machek - Mon, May 12, 2008 at 03:53:43PM +0200]
| On Sun 2008-05-11 22:46:38, Cyrill Gorcunov wrote:
| > To allow linker to catch sections overlapping we have to declare
| > them in appropriate order.
| > 
| > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| > ---
| > 
| > Please test and review
| 
| Looks okay to me, but I can't easily test it right now.
| 
| But I think Rafael tested identical patch, you can add my ACK in such
| case.
| 
| 								Pavel
| 

Yes, Rafael tested the same (in contents) patch. Actually there was
a bit time-screwed situation - I've proposed a solution, Peter was
agreed with, I said him that I'll cook a patch, meanwhile I've got an internet
connection problem, and at moment Rafael tested the same patch he made by own.
A bit funny situation ;) So I think in this patch should be then:

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Pavel Machek <pavel@suse.cz>

Anyway, thanks to all being involved ;)

		- Cyrill -
