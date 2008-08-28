Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYH1PD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYH1PD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 11:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbYH1PDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 11:03:46 -0400
Received: from relay2.globalproof.net ([194.146.153.25]:56068 "EHLO
	relay2.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbYH1PDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 11:03:45 -0400
From: Denys Fedoryshchenko <denys@visp.net.lb>
Organization: Virtual ISP
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: loaded router, excessive getnstimeofday in oprofile
Date: Thu, 28 Aug 2008 18:02:17 +0300
User-Agent: KMail/1.9.9
Cc: Joe Malicki <jmalicki@metacarta.com>, David Miller <davem@davemloft.net>,
       johnpol@2ka.mipt.ru, dada1@cosmosbay.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, juhlenko@akamai.com, sammy@sammy.net
References: <20080827.201020.17601834.davem@davemloft.net> <21915755.1327801219904892242.JavaMail.root@ouachita> <20080828072218.GI26610@one.firstfloor.org>
In-Reply-To: <20080828072218.GI26610@one.firstfloor.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200808281802.17867.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 August 2008, Andi Kleen wrote:
I hit one more bug, while deleting root class for htb on ifb0 i got tc stuck 
(and all operations related to tc), but there was some fixes for this things 
in net-2.6, so i tried to update git tree.

It seems i cannot test current net-2.6, because it is broken for me 
on USB part (fixed by workaround in init scripts), HPET totally broken in 
net-2.6, but works for latest main git from torvalds tree.
I have to wait when net-2.6 rebased to current torvalds tree, then i will try 
to test.
