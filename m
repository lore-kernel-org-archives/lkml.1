Return-Path: <linux-kernel-owner+w=401wt.eu-S1753021AbXIKOVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbXIKOVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 10:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbXIKOVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 10:21:44 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:39852 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbXIKOVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 10:21:43 -0400
Message-ID: <46E6A419.9070101@oracle.com>
Date: Tue, 11 Sep 2007 07:20:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Zhang Wei-r63237 <Wei.Zhang@freescale.com>
CC: paulus@samba.org, shannon.nelson@intel.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, galak@kernel.crashing.org,
       Zhu Ebony-r57400 <ebony.zhu@freescale.com>, dan.j.williams@intel.com
Subject: Re: [PATCH 5/5] Add DMA engine driver for Freescale MPC85xx processors.
References: <11891624582950-git-send-email-wei.zhang@freescale.com> <20070907085845.54dc88f8.randy.dunlap@oracle.com> <46B96294322F7D458F9648B60E15112C85D61C@zch01exm26.fsl.freescale.net>
In-Reply-To: <46B96294322F7D458F9648B60E15112C85D61C@zch01exm26.fsl.freescale.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang Wei-r63237 wrote:

>>> +/**
>>> + * fsl_chan_xfer_ld_queue -- Transfer the link descriptors 
>> in channel
>>> + *                           ld_queue.
>> The function's "short description" (unfortunately) must be on only one
>> line.  E.g.:
>>
>>  * fsl_chan_xfer_ld_queue - Transfer link descriptors in 
>> channel ld_queue.
>>
> 
> How about it's length greater than 80?

If it's close to 80+, you can just leave it like that.
If it's much longer, you can use this format:

/**
 * function_name - short description
 * @parameters: prm description
 *
 * Longer
 *      function
 *             description.
 */



Thanks,
~Randy
