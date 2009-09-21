Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbZIUHso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbZIUHso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 03:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbZIUHsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 03:48:42 -0400
Received: from dd2934.kasserver.com ([85.13.129.136]:38383 "EHLO
	dd2934.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbZIUHsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 03:48:42 -0400
Message-ID: <4AB72FDC.5090403@datenparkplatz.de>
Date: Mon, 21 Sep 2009 09:48:44 +0200
From: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Poor desktop responsiveness with background I/O-operations
References: <4AB59CBB.8090907@datenparkplatz.de>	 <20090920080728.73bfe2a1@infradead.org>	 <4AB5ECD0.7010903@datenparkplatz.de>	 <1253475521.9224.43.camel@marge.simson.net>  <4AB6C73C.1030004@gmail.com> <1253507034.23414.90.camel@marge.simson.net>
In-Reply-To: <1253507034.23414.90.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi and thanks for your reply!


Mike Galbraith wrote:
> nicing a shell or the dd should (and does) help a LOT.

If this is the only way to influence this, maybe the default settings
for the niceness of interactive and non-interactive tasks are not the
best choice. (Maybe a distribution problem in this case)



> reads are sync, more heavily affected by seek latency than writes.

But how does this explain the seconds-long delays?

If an interactive process causes a lot of seeks because of reads/writes
which "are sync", I see how this can greatly slow down otherwise
pipelined write operations, but the other way around?
