Return-Path: <linux-kernel-owner+w=401wt.eu-S1761890AbYDUOBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761890AbYDUOBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 10:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760040AbYDUOBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 10:01:24 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2138 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759866AbYDUOBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 10:01:23 -0400
Date: Mon, 21 Apr 2008 16:00:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: mingo@elte.hu, akpm@osdl.org, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v5)
Message-ID: <20080421140054.GB4685@ucw.cz>
References: <20080417165839.GA25198@Krystal> <20080417165944.GB25198@Krystal> <20080417201410.GB31616@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417201410.GB31616@Krystal>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-04-17 16:14:10, Mathieu Desnoyers wrote:
> (hopefully finally CCing LKML) :)
> 
> Implements an alternative iret with popf and return so trap and exception
> handlers can return to the NMI handler without issuing iret. iret would cause
> NMIs to be reenabled prematurely. x86_32 uses popf and far return. x86_64 has to
> copy the return instruction pointer to the top of the previous stack, issue a
> popf, loads the previous esp and issue a near return (ret).

sounds expensive. Does it slow down normal loads?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
