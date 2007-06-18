Return-Path: <linux-kernel-owner+w=401wt.eu-S1764383AbXFRRnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764383AbXFRRnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 13:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760566AbXFRRnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 13:43:11 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:46020 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760404AbXFRRnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 13:43:09 -0400
To: torvalds@linux-foundation.org
CC: mingo@elte.hu, cebbert@redhat.com, chris@atlee.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
In-reply-to: <alpine.LFD.0.98.0706180857120.14121@woody.linux-foundation.org>
	(message from Linus Torvalds on Mon, 18 Jun 2007 09:34:40 -0700 (PDT))
Subject: Re: [BUG] long freezes on thinkpad t60
References: <E1HrEIp-0005qy-00@dorka.pomaz.szeredi.hu> <20070524144447.GA25068@elte.hu>
 <E1HrGom-0006AC-00@dorka.pomaz.szeredi.hu> <20070524210153.GB19672@elte.hu>
 <E1HrWSH-0000mH-00@dorka.pomaz.szeredi.hu> <E1Hyrnk-0006On-00@dorka.pomaz.szeredi.hu>
 <20070616103707.GA28096@elte.hu> <E1I02Zx-0005qu-00@dorka.pomaz.szeredi.hu>
 <20070618064343.GA31113@elte.hu> <E1I0Baz-0006cP-00@dorka.pomaz.szeredi.hu>
 <20070618081204.GA11153@elte.hu> <alpine.LFD.0.98.0706180857120.14121@woody.linux-foundation.org>
Message-Id: <E1I0LEG-0008LQ-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Jun 2007 19:41:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm? Untested, I know. Maybe I overlooked something. But even the 
> generated assembly code looks fine (much better than it looked before!)

Boots and runs fine.  Fixes the freezes as well, which is not such a
big surprise, since basically any change in that function seems to do
that ;)

Miklos
