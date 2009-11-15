Return-Path: <linux-kernel-owner+w=401wt.eu-S1752098AbZKOLEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbZKOLEk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 06:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbZKOLEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 06:04:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55982 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbZKOLEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 06:04:39 -0500
Date: Sun, 15 Nov 2009 12:04:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
       fweisbec@gmail.com
Subject: Re: [PATCH v3] perf tools: New function to parse string representing
 size in bytes
Message-ID: <20091115110432.GA19862@elte.hu>
References: <20091115.185220.212229853.mitake@dcl.info.waseda.ac.jp>
 <1258280343-4359-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <20091115102859.GA24931@elte.hu>
 <20091115.195711.77834168.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091115.195711.77834168.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> > > +	length = atoll(str) * unit;
> > 
> > we might want to take a naming clue here and name this new function as 
> > atoll_exp(), to signal that it works like atoll, just with an extension 
> > for KB/MB/GB/etc. expressions?
> 
> Hm, how about "atoll_byteunit()"?
> This may have no ambiguity.

I'd suggest to name it in a generic way, in case we want to add other 
convenience conversions, hm?

Perhaps simply perf_atoll() - an extended version that understands byte 
units (and potentially more in the future).

	Ingo
