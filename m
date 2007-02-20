Return-Path: <linux-kernel-owner+w=401wt.eu-S1030491AbXBTWWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030491AbXBTWWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030500AbXBTWWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:22:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34660 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030491AbXBTWWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:22:50 -0500
Subject: Re: all syscalls initially taking 4usec on a P4? Re: nonblocking 
	UDPv4 recvfrom() taking 4usec @ 3GHz?
From: Arjan van de Ven <arjan@infradead.org>
To: bert hubert <bert.hubert@netherlabs.nl>
Cc: Rick Jones <rick.jones2@hp.com>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Josef Sipek <jsipek@fsl.cs.sunysb.edu>,
       Andi Kleen <andi@firstfloor.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070220221719.GA16263@outpost.ds9a.nl>
References: <20070219231447.GA4400@outpost.ds9a.nl>
	 <p73d545drx6.fsf@bingen.suse.de> <20070220162714.GA3245@outpost.ds9a.nl>
	 <20070220164124.GA24930@2ka.mipt.ru>
	 <20070220184242.GA30077@filer.fsl.cs.sunysb.edu>
	 <20070220184859.GA1949@2ka.mipt.ru> <20070220193319.GA8800@outpost.ds9a.nl>
	 <45DB6FD8.4050106@hp.com>  <20070220221719.GA16263@outpost.ds9a.nl>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 20 Feb 2007 23:22:27 +0100
Message-Id: <1172010148.3531.158.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I'm trying to figure out which processes have the most impact, I had already
> killed anything non-essential. But that still leaves 140 pids.

btw if you have systemtap on your system you can see who is doing evil
with

http://www.fenrus.org/cstop.stp

also.. running "vmstat 3" and looking at the "cs" column is interesting;
it shouldn't be above 50 or so in idle (well not above 10 but our
userland stinks too much for that)


