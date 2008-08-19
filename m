Return-Path: <linux-kernel-owner+w=401wt.eu-S1759433AbYHSVlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433AbYHSVlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbYHSVkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:40:24 -0400
Received: from relay2.globalproof.net ([194.146.153.25]:40022 "EHLO
	relay2.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821AbYHSVkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:40:22 -0400
From: Denys Fedoryshchenko <denys@visp.net.lb>
Organization: Virtual ISP
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT]: Networking
Date: Wed, 20 Aug 2008 00:39:08 +0300
User-Agent: KMail/1.9.9
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <alpine.LFD.1.10.0808190952000.3324@nehalem.linux-foundation.org> <20080819.140458.236030589.davem@davemloft.net> <alpine.LFD.1.10.0808191411390.3324@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808191411390.3324@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808200039.08948.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oh, I'm sure that enabling TSO speeds things up, but apparently it also
> basically enables a code-path that hasn't been enabled since at least
> 2.6.23, no?
Well i report about performance regression before too, seems related case,
but my report was unclear.

And the bug was terrible for me, it was causing very bad performance on 
REDIRECT and loopback transfers. I am testing also recent net-2.6 with this 
loopback changes, it seems improve things for me much. So it is really 
important bugfix for me too.

There is always chances that some fix will cause regression, i will try to 
test this changes on intensive real-life workloads to make sure all fine.
