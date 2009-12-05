Return-Path: <linux-kernel-owner+w=401wt.eu-S1757632AbZLEBRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632AbZLEBRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 20:17:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757597AbZLEBRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 20:17:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50298 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757482AbZLEBRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 20:17:08 -0500
Message-ID: <4B19B4FA.5080904@gmail.com>
Date: Sat, 05 Dec 2009 02:18:50 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
       bruce.w.allan@intel.com, peter.p.waskiewicz.jr@intel.com,
       john.ronciak@intel.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       netdev@vger.kernel.org
Subject: Re: [PATCH 06/31] Constify struct e1000_mac_operations for 2.6.32
 v1
References: <4B198670.2000406@gmail.com>	<4B198A33.7080705@gmail.com>	<4B19A337.6060808@gmail.com> <20091205114048.37df384e.sfr@canb.auug.org.au>
In-Reply-To: <20091205114048.37df384e.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Emese,
> 
> On Sat, 05 Dec 2009 01:03:03 +0100 Emese Revfy <re.emese@gmail.com> wrote:
>> --- a/drivers/net/e1000e/82571.c
>> +++ b/drivers/net/e1000e/82571.c
>> @@ -212,6 +212,7 @@ static s32 e1000_init_mac_params_82571(struct e1000_adapter *adapter)
>>  {
>>  	struct e1000_hw *hw = &adapter->hw;
>>  	struct e1000_mac_info *mac = &hw->mac;
>> +	/* cannot be const */
>>  	struct e1000_mac_operations *func = &mac->ops;
> 
> Adding to the comment to say why it can't be const may allow us to fix
> this later ...

Ok, in the next patch series I will explain each case.
