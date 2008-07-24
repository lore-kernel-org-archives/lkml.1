Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbYGXLv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbYGXLv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 07:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbYGXLvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 07:51:19 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39601 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbYGXLvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 07:51:18 -0400
Date: Thu, 24 Jul 2008 20:51:09 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rafal Wijata <devnull@wijata.com>
Subject: Re: Odd swapping issue
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <488761F0.4040906@wijata.com>
References: <488761F0.4040906@wijata.com>
Message-Id: <20080724202656.86A3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafal

> vm.swappiness was decreased to 30, to avoid excessive swap usage, but no 
> avail.
> It's application and nfs server/client if it matters. During that 
> "memory sweep" I observed many nfsd processes(kernel threads?) in D state.

I think no related.

nfsd always remain D state.
because if nfsd waiting to new packet, ps (or other tool) display "D".


