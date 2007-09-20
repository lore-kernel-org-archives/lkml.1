Return-Path: <linux-kernel-owner+w=401wt.eu-S1756368AbXITN0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368AbXITN0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 09:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbXITN0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 09:26:09 -0400
Received: from herkules.vianova.fi ([194.100.28.129]:40548 "HELO
	mail.vianova.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753914AbXITN0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 09:26:08 -0400
Date: Thu, 20 Sep 2007 16:25:33 +0300
From: Ville Herva <v@iki.fi>
To: Willy Tarreau <w@1wt.eu>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: 2.4.35 SMP: ext3_readdir: bad entry in directory #323888: rec_len is smaller than minimal
Message-ID: <20070920132533.GC5076@vianova.fi>
Reply-To: v@iki.fi
References: <20070918122314.GL29062@vianova.fi> <20070918151206.GC13304@atrey.karlin.mff.cuni.cz> <20070918160949.GR29062@vianova.fi> <20070918162256.GA3280@atrey.karlin.mff.cuni.cz> <20070918163326.GT29062@vianova.fi> <20070918214705.GG10199@1wt.eu> <20070920124537.GB5076@vianova.fi> <20070920132055.GB12291@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070920132055.GB12291@1wt.eu>
X-Operating-System: Linux herkules.vianova.fi 2.4.35
User-Agent: Mutt/1.5.10i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 03:20:55PM +0200, you [Willy Tarreau] wrote:
> OK. And your config seems perfectly standard.
> 
> > gcc 2.96-129:
> > cat /proc/version 
> > Linux version 2.4.35 (root) (gcc version 2.96 20000731 (Red Hat Linux 7.2 2.96-129.7.2)) #1 SMP Thu Aug 9 10:35:37 EEST 2007
> 
> I used not to trust 2.96, but I wouldn't accuse it now.

The box was virtualized a while ago and 2.4.32-rc1 and earlier 2.4 compiled
with the same compiler ran very solidly for years. It was UP before
virtualization, though.
 
> > share of chipset bugs with older Via chipsets, but I think it's very likely
> > in this case.
> 
> I think you meant "unlikely".

Yep, sorry for the typo.
 
> > This could very well be a VMware bug, but I wanted to know if this rings
> > bells for someone.
> 
> It could also be a problem with the host OS, drivers, hardware, etc...

Yes, pretty much anything. There's no solid evidency of anything, only
guesses of what might be more likely and what might be less likely...

If it happens again, I'll try to debug more.



-- v -- 

v@iki.fi

