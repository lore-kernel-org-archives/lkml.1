Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbYDUIYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbYDUIYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbYDUIYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:24:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38879 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbYDUIYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:24:22 -0400
Date: Mon, 21 Apr 2008 17:24:04 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Chinner <dgc@sgi.com>
Subject: Re: OOM killer doesn't kill the right task....
Cc: kosaki.motohiro@jp.fujitsu.com, lkml <linux-kernel@vger.kernel.org>,
       xfs-oss <xfs@oss.sgi.com>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20080421070123.GM108924158@sgi.com>
References: <20080421070123.GM108924158@sgi.com>
Message-Id: <20080421172255.C45A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David

> Running in a 512MB UML system without swap, XFSQA test 084 reliably
> kills the kernel completely as the OOM killer is unable to find a
> task to kill. log output is below.
> 
> I don't know when it started failing - ISTR this working just fine
> on 2.6.24 kernels.

Can you reproduce it on non UML box?



