Return-Path: <linux-kernel-owner+w=401wt.eu-S1752235AbZKOLc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbZKOLc3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 06:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZKOLc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 06:32:28 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:60800 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbZKOLc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 06:32:28 -0500
Date: Sun, 15 Nov 2009 20:32:28 +0900 (JST)
Message-Id: <20091115.203228.50774015.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
       fweisbec@gmail.com
Subject: Re: [PATCH v3] perf tools: New function to parse string
 representing size in bytes
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20091115110432.GA19862@elte.hu>
References: <20091115102859.GA24931@elte.hu>
	<20091115.195711.77834168.mitake@dcl.info.waseda.ac.jp>
	<20091115110432.GA19862@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v3] perf tools: New function to parse string representing size in bytes
Date: Sun, 15 Nov 2009 12:04:32 +0100

> 
> * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> 
> > > > +	length = atoll(str) * unit;
> > > 
> > > we might want to take a naming clue here and name this new function as 
> > > atoll_exp(), to signal that it works like atoll, just with an extension 
> > > for KB/MB/GB/etc. expressions?
> > 
> > Hm, how about "atoll_byteunit()"?
> > This may have no ambiguity.
> 
> I'd suggest to name it in a generic way, in case we want to add other 
> convenience conversions, hm?
> 
> Perhaps simply perf_atoll() - an extended version that understands byte 
> units (and potentially more in the future).

OK. I name the function perf_atoll().
I'll send the patch later.

