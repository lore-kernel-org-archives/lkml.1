Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbYH1TB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbYH1TB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 15:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbYH1TBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 15:01:15 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55877 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbYH1TBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 15:01:14 -0400
Date: Thu, 28 Aug 2008 22:01:13 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Denys Fedoryshchenko <denys@visp.net.lb>
cc: Andi Kleen <andi@firstfloor.org>, Joe Malicki <jmalicki@metacarta.com>,
       David Miller <davem@davemloft.net>, johnpol@2ka.mipt.ru,
       dada1@cosmosbay.com, Netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, juhlenko@akamai.com,
       sammy@sammy.net
Subject: Re: loaded router, excessive getnstimeofday in oprofile
In-Reply-To: <200808281802.17867.denys@visp.net.lb>
Message-ID: <Pine.LNX.4.64.0808282155480.7618@wrl-59.cs.helsinki.fi>
References: <20080827.201020.17601834.davem@davemloft.net>
 <21915755.1327801219904892242.JavaMail.root@ouachita>
 <20080828072218.GI26610@one.firstfloor.org> <200808281802.17867.denys@visp.net.lb>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008, Denys Fedoryshchenko wrote:

> On Thursday 28 August 2008, Andi Kleen wrote:
> I hit one more bug, while deleting root class for htb on ifb0 i got tc stuck 
> (and all operations related to tc), but there was some fixes for this things 
> in net-2.6, so i tried to update git tree.
> 
> It seems i cannot test current net-2.6, because it is broken for me 
> on USB part (fixed by workaround in init scripts), HPET totally broken in 
> net-2.6, but works for latest main git from torvalds tree.
> I have to wait when net-2.6 rebased to current torvalds tree, then i will try 
> to test.

You could always pull net-2.6 to Linus' tree by yourself.

...And about the workflow, net-2.6 isn't rebased, instead Linus just 
pulls it in to his tree. 

-- 
 i.
