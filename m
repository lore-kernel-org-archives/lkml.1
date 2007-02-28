Return-Path: <linux-kernel-owner+w=401wt.eu-S1751602AbXB1Qde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbXB1Qde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 11:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbXB1Qde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 11:33:34 -0500
Received: from terminus.zytor.com ([192.83.249.54]:50128 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbXB1Qdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 11:33:33 -0500
Message-ID: <45E5AED0.5050206@zytor.com>
Date: Wed, 28 Feb 2007 08:33:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: Kumar Gala <galak@kernel.crashing.org>,
       "Mathiasen, Torben" <Torben.Mathiasen@hp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
References: <45E46976.6060600@freescale.com> <93C4769E3BED6B42B7203BD6F065654C08C5D6E8@dmoexc01.emea.cpqcorp.net> <45E57CE5.5010003@zytor.com> <93C4769E3BED6B42B7203BD6F065654C08C5D7FF@dmoexc01.emea.cpqcorp.net> <45E593C2.6020004@freescale.com> <93C4769E3BED6B42B7203BD6F065654C08C5D8FD@dmoexc01.emea.cpqcorp.net> <0DA3FFD2-CFB8-44FB-872B-00D85B11213B@kernel.crashing.org> <45E59BFC.8020206@zytor.com> <45E5ADCF.5050406@freescale.com>
In-Reply-To: <45E5ADCF.5050406@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi wrote:
> H. Peter Anvin wrote:
> 
>> It sounds like the QE driver should be moved to a separate minor 
>> range, and given 8 minors.
> 
> I just had a thought - since udev doesn't care about major/minor number 
> assignments, can we say that the limit is 4 devices if you're not using 
> udev, and 8 otherwise?
> 

That seems pretty silly.

	-hpa
