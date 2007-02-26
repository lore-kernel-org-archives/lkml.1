Return-Path: <linux-kernel-owner+w=401wt.eu-S1030391AbXBZSTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030391AbXBZSTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 13:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030397AbXBZSTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 13:19:54 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43406 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030391AbXBZSTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 13:19:53 -0500
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
From: Arjan van de Ven <arjan@infradead.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070226173701.GD22454@2ka.mipt.ru>
References: <20070221211355.GA7302@elte.hu>
	 <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
	 <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com>
	 <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru>
	 <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org>
	 <20070226131133.GA11777@elte.hu>  <20070226173701.GD22454@2ka.mipt.ru>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 26 Feb 2007 10:19:03 -0800
Message-Id: <1172513950.3280.388.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-26 at 20:37 +0300, Evgeniy Polyakov wrote:

> I tend to agree.
> Yes, some loads require event driven model, other can be done using
> threads.

event driven model is really complex though. For event driven to work
well you basically can't tolerate blocking calls at all ...
open() blocks on files. read() may block on metadata reads (say indirect
blockgroups) not just on datareads etc etc. It gets really hairy really
quick that way.

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

