Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYLAV2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYLAV2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 16:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbYLAV2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 16:28:20 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:62366 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbYLAV2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:28:19 -0500
Date: Mon, 1 Dec 2008 13:27:54 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, shemminger@vyatta.com,
       rmk@arm.linux.org.uk
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for December 1 (etherh network driver)
Message-Id: <20081201132754.9c5055d3.randy.dunlap@oracle.com>
In-Reply-To: <20081201190827.2d02b1a5.sfr@canb.auug.org.au>
References: <20081201190827.2d02b1a5.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.493456DE.0112:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008 19:08:27 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20081128:
> 
> Today's tree fails the powerpc allyesconfig build.


Steve (Hemminger),
Please look into this build error:
  http://kisskb.ellerman.id.au/kisskb/buildresult/58438/

It looks like the network driver at drivers/net/arm/etherh.c
is missing the conversion to use netdev_ops.

---
~Randy
