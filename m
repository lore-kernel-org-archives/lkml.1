Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbYKPIOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbYKPIOx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 03:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYKPIOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 03:14:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39547
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751202AbYKPIOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 03:14:45 -0500
Date: Sun, 16 Nov 2008 00:14:44 -0800 (PST)
Message-Id: <20081116.001444.97681353.davem@davemloft.net>
To: adobriyan@gmail.com
Cc: laijs@cn.fujitsu.com, akpm@linux-foundation.org, menage@google.com,
       kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       jens.axboe@oracle.com, jack@suse.cz, jes@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081116044901.GA24624@x200.localdomain>
References: <491FA28B.2070003@cn.fujitsu.com>
	<20081116044901.GA24624@x200.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sun, 16 Nov 2008 07:49:01 +0300

> On Sun, Nov 16, 2008 at 12:33:15PM +0800, Lai Jiangshan wrote:
> > some subsystem needs vmalloc() when required memory is large.
> > but current kernel has not APIs for this requirement.
> 
> It doesn't mean there should be such an API.

If it leads to lots of code duplication, which this case has, that is
enough reason to provide helper functions.
