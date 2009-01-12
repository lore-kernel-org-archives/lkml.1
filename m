Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbZALLfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbZALLfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 06:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbZALLfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 06:35:22 -0500
Received: from styx.suse.cz ([82.119.242.94]:36926 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751023AbZALLfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 06:35:21 -0500
Date: Mon, 12 Jan 2009 12:35:20 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: build breakage -- paravirt_{alloc,free}_ldt
In-Reply-To: <20090112111827.GB18265@elte.hu>
Message-ID: <alpine.LNX.1.10.0901121234360.5377@jikos.suse.cz>
References: <alpine.LNX.1.10.0901121121410.5377@jikos.suse.cz> <20090112105202.GF10405@elte.hu> <alpine.LNX.1.10.0901121211000.5377@jikos.suse.cz> <20090112111827.GB18265@elte.hu>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2009, Ingo Molnar wrote:

> > Puzzled. On one system, I still get this build error even after make 
> > mrpoper (I use this machine to build kernel routinely, so it certainly 
> > didn't happen a few days ago).
> > But I just tried on different system, and there is builds flawlessly. 
> > It's gcc 4.3.1 vs 4.3.2. I will check a little bit more.
> beyond mrproper you might want to try 'git checkout HEAD . -f' as well, to 
> get a forced checkout of the current working tree. Should there be any 
> corruption in any of the source code files this will get rid of it.

I did a completely fresh clone instead, and it works since that ... 
strange. Anyway sorry for alse alarm.

-- 
SUSE Labs
