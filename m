Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbYGIONl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbYGIONl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 10:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbYGIONb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 10:13:31 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:38762 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYGION3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 10:13:29 -0400
Message-ID: <4874C77F.7070602@hp.com>
Date: Wed, 09 Jul 2008 10:13:19 -0400
From: jim owens <jowens@hp.com>
User-Agent: Mozilla/5.0 (X11; U; OSF1 alpha; en-US; rv:1.7.13) Gecko/20060421
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: Dave Chinner <david@fromorbit.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org, pavel@suse.cz,
       t-sato@yk.jp.nec.com, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
       dm-devel@redhat.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       mtk.manpages@googlemail.com
Subject: Re: [PATCH 3/3] Add timeout feature
References: <20080709005254.GQ11558@disturbed> <20080709010922.GE9957@mit.edu> <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu> <20080708235502.1c52a586@infradead.org> <20080709071346.GS11558@disturbed> <20080709110900.GI9957@mit.edu> <20080709114958.GV11558@disturbed> <4874C3E8.20804@hp.com>
In-Reply-To: <4874C3E8.20804@hp.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops..

 > WHY A TIMEOUT - need a way for operator to abort the
 > freeze

instead of "abort" I should have said "limit" because
it is really proactive control (so they will not get
called in the middle of the night by pissed users).

I forgot to make it clear that TIMEOUT is the same as AUTO-THAW
in logging errors so the adnin knows they have a bad snapshot and
can do it again.

I also forgot to say that our customers all say they can deal
with retrying a snapshot, but not with unknown bad snapshots
and most definitely not with killing their 24/7 operations!

jim
