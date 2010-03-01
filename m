Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab0CABm4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 20:42:56 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53392 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab0CABmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 20:42:54 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Memory management woes - order 1 allocation failures
Cc: kosaki.motohiro@jp.fujitsu.com,
       Christoph Lameter <cl@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Mel Gorman <mel@skynet.ie>
In-Reply-To: <84144f021002260917q61f7c255rf994425f3a613819@mail.gmail.com>
References: <alpine.DEB.2.00.1002261042020.7719@router.home> <84144f021002260917q61f7c255rf994425f3a613819@mail.gmail.com>
Message-Id: <20100301103546.DD86.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  1 Mar 2010 10:42:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> AFAICT, even in the worst case, the latter call-site is well below 4K.
> I have no idea of the tty one.

afaik, tty_buffer_request_room() try to expand its buffer size for efficiency. but Its failure
doesn't cause any user visible failure. probably we can mark it as NOWARN.

In worst case, maximum tty buffer size is 64K, it can make allocation failure easily.


Alan, Can you please tell us your mention?



