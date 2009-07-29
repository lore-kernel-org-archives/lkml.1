Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbZG2XlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbZG2XlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 19:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754826AbZG2XlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 19:41:00 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:41053 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865AbZG2XlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 19:41:00 -0400
Message-ID: <4A70DE01.4030905@mnementh.co.uk>
Date: Thu, 30 Jul 2009 00:40:49 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: pHilipp Zabel <philipp.zabel@gmail.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, Magnus Damm <damm@opensource.se>,
       akpm@linux-foundation.org, Matt Fleming <matt@console-pimps.org>,
       Philip Langdale <philipl@overt.org>
Subject: Re: [PATCH] tmio_mmc: Optionally support using platform clock
References: <Pine.LNX.4.64.0907280937000.4943@axis700.grange>	 <74d0deb30907290820x13214f68u82dea4ad229ebdac@mail.gmail.com> <74d0deb30907290832u6f718443nab9daf996417c9be@mail.gmail.com>
In-Reply-To: <74d0deb30907290832u6f718443nab9daf996417c9be@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pHilipp Zabel wrote:

>>>  struct tmio_mmc_data {
>>>        const unsigned int              hclk;
>>> +       const char                      *clk_name;
>> Drop that.
> 
> Actually, this struct can be dropped completely and the HCLK rate can
> be determined with clk_get_rate.

Actually it cant because MFD devices have different hclk frequencies, 
and the mmc driver needs to know this. MFD drivers cannot pass the hclk 
rate in using the clk API at present.

-Ian

