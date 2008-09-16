Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbYIPRit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbYIPRit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 13:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbYIPRil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 13:38:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51583 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbYIPRik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 13:38:40 -0400
Message-ID: <48CFEF3F.5040901@manoweb.com>
Date: Tue, 16 Sep 2008 10:39:11 -0700
From: Alessio Sangalli <alesan@manoweb.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver for tightly coupled memory
References: <48CEC71F.3000006@manoweb.com> <20080916093513.GF1916@fluff.org.uk>
In-Reply-To: <20080916093513.GF1916@fluff.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18c0vbR2G6ksUUTFUaKLoLtOh42DlHOVGu8pz9
 m9+zYySxx+quJveLWHtj9sQIBE0wpgR1QccA59+Rtvlrnax+aq
 E6lqiSXO52XjlYTp6PJaA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Dooks wrote:

> This isn't the right list to be discussing this on, try looking for
> linux-arm-kernel instead. It will get your question to the attention
> of more people knowledgable about the ARM specifics.

I disagree, something like a TCM can very well be present in any
architecture, after all it's some kind of fast memory mapped to an
address, nothing special from a software point of view. I will ask on
the ARM mailing list however.


> IIRC, there's no current support for using TCMs.

I think I will write a module that implements a software FIFO. One
function to allocate a FIFO n words deep, a "push" and a "pop" and
similar. The calling module will have to setup the FIFO and use it
probably in ISRs or similar (the policy will totally remain in the
caller module). Any comments on such approach?

bye
Alessio
