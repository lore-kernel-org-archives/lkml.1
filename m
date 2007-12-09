Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbXLIGzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbXLIGzN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 01:55:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbXLIGzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 01:55:01 -0500
Received: from main.gmane.org ([80.91.229.2]:56642 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbXLIGzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 01:55:00 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jon Masters <jonathan@jonmasters.org>
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Date: Sun, 09 Dec 2007 01:52:05 -0500
Organization: World Organi[sz]ation Of Broken Dreams
Message-ID: <1197183090.12636.15.camel@perihelion>
References: <20071204114125.GA17310@torres.zugschlus.de>
	 <47584E35.7030409@tmr.com> <20071208220345.GE20441@stusta.de>
	 <200712090010.10362.ismail@pardus.org.tr>
	 <20071208234612.GQ17037@thunk.org>  <20071209052149.GH15227@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: boston.jonmasters.org
In-Reply-To: <20071209052149.GH15227@1wt.eu>
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-12-09 at 06:21 +0100, Willy Tarreau wrote:

> Wouldn't it be possible to mix the data with the pid+uid of the reading
> process so that even if another one tries to collect data from urandom,
> he cannot predict what another process will get ? BTW, I think that the
> tuple (pid,uid,timestamp of open) is unpredictable and uncontrollable
> enough to provide one or even a few bits of entropy by itself.

Timestamp perhaps, but pid/uid are trivially guessable in automated
environments, such as LiveCDs. And if you're also running on an embedded
system without a RTC (common, folks like to save a few cents) then it's
all pretty much "trivially" guessable on some level.

Jon.



