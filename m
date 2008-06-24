Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbYFXBj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbYFXBj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 21:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbYFXBjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 21:39:17 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:41175 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbYFXBjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 21:39:16 -0400
Date: Tue, 24 Jun 2008 10:37:09 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, balbir@linux.vnet.ibm.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org
Subject: Re: [bad page] memcg: another bad page at page migration
 (2.6.26-rc5-mm3 + patch collection)
Message-Id: <20080624103709.3b5db84d.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20080623204448.2c4326ab.nishimura@mxp.nes.nec.co.jp>
References: <20080623145341.0a365c67.nishimura@mxp.nes.nec.co.jp>
	<20080623150817.628aef9f.kamezawa.hiroyu@jp.fujitsu.com>
	<20080623202111.f2c54e21.kamezawa.hiroyu@jp.fujitsu.com>
	<20080623204448.2c4326ab.nishimura@mxp.nes.nec.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't use shmem explicitly, but I'll test this patch anyway
> and report the result.
> 
Unfortunately, this patch doesn't solve my problem, hum...
I'll dig more, too.
In my test, I don't use large amount of memory, so I think
no swap activities happens, perhaps.

Anyway, I agree that this patch itself is needed for shmem migration.


Thanks,
Daisuke Nishimura.
