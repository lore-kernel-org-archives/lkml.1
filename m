Return-Path: <linux-kernel-owner+w=401wt.eu-S932231AbXDXJsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbXDXJsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 05:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932286AbXDXJsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 05:48:55 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:40057 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbXDXJsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 05:48:54 -0400
To: a.p.zijlstra@chello.nl
CC: miklos@szeredi.hu, neilb@suse.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com
In-reply-to: <1177406817.26937.65.camel@twins> (message from Peter Zijlstra on
	Tue, 24 Apr 2007 11:26:57 +0200)
Subject: Re: [PATCH 10/10] mm: per device dirty threshold
References: <20070420155154.898600123@chello.nl>
	 <20070420155503.608300342@chello.nl>
	 <17965.29252.950216.971096@notabene.brown>
	 <1177398589.26937.40.camel@twins>
	 <E1HgGF4-00008p-00@dorka.pomaz.szeredi.hu>
	 <1177403494.26937.59.camel@twins>
	 <E1HgH69-0000Fl-00@dorka.pomaz.szeredi.hu> <1177406817.26937.65.camel@twins>
Message-Id: <E1HgHcG-0000J5-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 24 Apr 2007 11:47:20 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Ahh, now I see; I had totally blocked out these few lines:
> 
> 			pages_written += write_chunk - wbc.nr_to_write;
> 			if (pages_written >= write_chunk)
> 				break;		/* We've done our duty */
> 
> yeah, those look dubious indeed... And reading back Neil's comments, I
> think he agrees.
> 
> Shall we just kill those?

I think we should.

Athough I'm a little afraid, that Akpm will tell me again, that I'm a
stupid git, and that those lines are in fact vitally important ;)

Miklos
