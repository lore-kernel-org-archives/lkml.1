Return-Path: <linux-kernel-owner+w=401wt.eu-S1759900AbXIRQeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900AbXIRQeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 12:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759333AbXIRQeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 12:34:09 -0400
Received: from herkules.vianova.fi ([194.100.28.129]:51216 "HELO
	mail.vianova.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759095AbXIRQeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 12:34:08 -0400
Date: Tue, 18 Sep 2007 19:33:26 +0300
From: Ville Herva <v@iki.fi>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.4.35 SMP: ext3_readdir: bad entry in directory #323888: rec_len is smaller than minimal
Message-ID: <20070918163326.GT29062@vianova.fi>
Reply-To: v@iki.fi
References: <20070918122314.GL29062@vianova.fi> <20070918151206.GC13304@atrey.karlin.mff.cuni.cz> <20070918160949.GR29062@vianova.fi> <20070918162256.GA3280@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918162256.GA3280@atrey.karlin.mff.cuni.cz>
X-Operating-System: Linux herkules.vianova.fi 2.4.35
User-Agent: Mutt/1.5.10i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 06:22:56PM +0200, you [Jan Kara] wrote:
> > Sorry for the sparse details, but when you have these kind of problems on
> > live servers, you tend to forget the debuggability...
>   Yes, I can understand that :). It's just that now it's hard to find
> out what has really happened. Anyway, thanks for your report.

If we are really lucky or unlucky it will happen again. 

Zeroed-out block just might be a kernel problem (SMP race, whatever) -
random corruption would more likely be a hardware problem. There were no IO
error either. But, 2.4 ext3 has been pretty extensively tested, so I don't
suppose that's likely either. And judging from
http://www.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.3[45] there
haven't been many changes to ext3 lately either.
 


-- v -- 

v@iki.fi

