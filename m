Return-Path: <linux-kernel-owner+w=401wt.eu-S1760461AbXLLTcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760461AbXLLTcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbXLLTcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:32:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40502 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbXLLTcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:32:09 -0500
Date: Wed, 12 Dec 2007 20:32:13 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Rene Herman <rene.herman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
Message-ID: <20071212193213.GF21864@one.firstfloor.org>
References: <475F1DC6.5090403@keyaccess.nl> <20071212052304.GB20883@fattire.cabal.ca> <476035C0.1040708@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476035C0.1040708@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> "=A" works on 32-bit systems (only), obviously, and gcc will generally 
> produce slightly better code as a result (gcc could really use a 
> register renaming/copy propagation step *after* multi-register entities 

I believe gcc 4.3 (or maybe 4.2) does that already -- it splits them much 
earlier.

-Andi
