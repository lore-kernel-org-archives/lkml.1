Return-Path: <linux-kernel-owner+w=401wt.eu-S1759713AbXF3Oq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759713AbXF3Oq6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 10:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757685AbXF3Oqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 10:46:48 -0400
Received: from mga05.intel.com ([192.55.52.89]:55183 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756854AbXF3Oqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 10:46:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,480,1175497200"; 
   d="scan'208";a="262933494"
Message-ID: <46866C6B.9010801@linux.intel.com>
Date: Sat, 30 Jun 2007 07:44:59 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: =?ISO-8859-1?Q?T=F6r=F6k_Edvin?= <edwintorok@gmail.com>,
       netdev@vger.kernel.org, power@bughost.org, zambrano@broadcom.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] b44: power down PHY when interface down
References: <4354d3270706300447ladcda4by987b1f87963112f9@mail.gmail.com> <20070630120541.GA21339@srcf.ucam.org>
In-Reply-To: <20070630120541.GA21339@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Sat, Jun 30, 2007 at 02:47:35PM +0300, Török Edvin wrote:
>> When the interface is down (or driver removed), the BroadCom 44xx card 
>> remains
>> powered on, and both its MAC and PHY is using up power.
>> This patch makes the driver issue a MAC_CTRL_PHY_PDOWN when the interface
>> is halted, and does a partial chip reset turns off the activity LEDs too.
> 
> Do you still get link beat detection when the phy is powered down?
> 
does that matter?
If the interface is down, nic drivers aren't expected to detect 
link... if userspace wants to find link status it should have the 
interface up.
