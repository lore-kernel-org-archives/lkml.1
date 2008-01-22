Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbYAVQYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbYAVQYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 11:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbYAVQYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 11:24:11 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43008 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbYAVQYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 11:24:11 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4796189F.8070506@s5r6.in-berlin.de>
Date: Tue, 22 Jan 2008 17:23:59 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Denys Fedoryshchenko <denys@visp.net.lb>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: 2.6.24-rc7 to 2.6.24-rc8 possible regression
References: <20080121160255.M12670@visp.net.lb> <47952094.9050102@s5r6.in-berlin.de> <20080122110448.M46928@visp.net.lb>
In-Reply-To: <20080122110448.M46928@visp.net.lb>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Fedoryshchenko wrote:
> No, i am using vanilla kernel. It is one of production machines, and as i 
> know screen is not using epoll.

OK, but the trace shows that it is the epoll recursion again.

> I will try to apply on all my production machines this patch. Sorry if it is 
> related.

Well, let's hope that the lockdep annotation or whatever other fix gets
into mainline sooner than later.  Which reminds me to test my setup
again which appeared to be able to reproduce the __wake_up recursion on
my command...
-- 
Stefan Richter
-=====-==--- ---= =-==-
http://arcgraph.de/sr/
