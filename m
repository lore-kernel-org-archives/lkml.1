Return-Path: <linux-kernel-owner+w=401wt.eu-S1763506AbYD3SHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763506AbYD3SHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYD3SG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:06:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42248 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462AbYD3SG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:06:57 -0400
Date: Wed, 30 Apr 2008 20:06:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Al Viro <viro@ZenIV.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] x86: !x & y typo in mtrr code
Message-ID: <20080430180629.GB28338@elte.hu>
References: <1209268817.14173.43.camel@brick> <20080427042051.GL5882@ZenIV.linux.org.uk> <20080429210435.GA23008@elte.hu> <20080430064603.GA3602@atjola.homenet> <20080430093233.GD23528@elte.hu> <20080430121738.GA4559@atjola.homenet> <20080430123536.GD30735@elte.hu> <1209569734.24729.65.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209569734.24729.65.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> That's precisely why I've been sending all of the sparse cleanup 
> patches lately, to try and get the output down to something more 
> managable.  You may want to upgrade your sparse to one that 
> understands __cold though.

yep, and i wholeheartedly agree with those efforts of bringing the 
Sparse noise baseline back to near zero. That way it will be useful for 
the casual human look and normal patch workflow as well, not just 
(expensive to maintain and acquire) delta statistics.

	Ingo
