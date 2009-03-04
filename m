Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbZCDHny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbZCDHny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 02:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbZCDHnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 02:43:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38697
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751960AbZCDHnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 02:43:42 -0500
Date: Tue, 03 Mar 2009 23:43:27 -0800 (PST)
Message-Id: <20090303.234327.81716668.davem@davemloft.net>
To: bart@jukie.net
Cc: greearb@candelatech.com, shemminger@vyatta.com, dada1@cosmosbay.com,
       frank.blaschka@de.ibm.com, kaber@trash.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.29-rc* QinQ vlan trunking regression
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090228180541.GA729@jukie.net>
References: <20090228180541.GA729@jukie.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bart Trojanowski <bart@jukie.net>
Date: Sat, 28 Feb 2009 13:05:41 -0500

> 2.6.29-rc* introduces a bug that causes a crash when a vlan is put into
> another vlan, so called vlan trunking or QinQ.
> 
> I can reproduce it reliably with:
> 
>   $ modprobe 8021q
>   $ vconfig add eth1 5
>   $ ifconfig eth1.5 up
>   $ vconfig add eth1.5 4

Stephen please fix this.
