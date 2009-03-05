Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbZCEOBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbZCEOBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 09:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbZCEOBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 09:01:32 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:51229 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843AbZCEOBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 09:01:31 -0500
Date: Thu, 5 Mar 2009 15:01:25 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Markus <M4rkusXXL@web.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Zdenek Kabelac <zkabelac@redhat.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: drop_caches ...
Message-ID: <20090305140125.GD646@ics.muni.cz>
References: <200903041057.34072.M4rkusXXL@web.de> <200903041947.41542.M4rkusXXL@web.de> <20090305004850.GA6045@localhost> <200903051255.35407.M4rkusXXL@web.de> <20090305133603.GA22442@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090305133603.GA22442@localhost>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 05 Mar 2009 15:01:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 09:36:03PM +0800, Wu Fengguang wrote:
> > filesize and "cached" the amount of the file being in cache (why can 
> > this be bigger than the file?!).
> 
>           size = file size in bytes
>         cached = cached pages
> 
> So it's normal that (size > cached).

and one more thing. It seems that at least in the version of filecache I have,
the size and cached are in kB rather than in B.

-- 
Luká¹ Hejtmánek
