Return-Path: <linux-kernel-owner+w=401wt.eu-S1761036AbXH3OLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761036AbXH3OLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760623AbXH3OLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:11:22 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:39889 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760551AbXH3OLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:11:21 -0400
Message-ID: <46D6CEF3.3070701@aitel.hist.no>
Date: Thu, 30 Aug 2007 16:06:43 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Xavier Bestel <xavier.bestel@free.fr>
CC: Robert Hancock <hancockr@shaw.ca>, Daniel Drake <ddrake@brontes3d.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: speeding up swapoff
References: <fa.j/pO3mTWDugTdvZ3XNr9XpvgzPQ@ifi.uio.no>	 <fa.ed9fasZXOwVCrbffkPQTX7G3a7g@ifi.uio.no>	 <fa./NZA3biuO1+qW5pW8ybdZMDWcZs@ifi.uio.no> <46D61F48.5090406@shaw.ca>	 <46D6CC35.90207@aitel.hist.no> <1188482815.1131.374.camel@frg-rhel40-em64t-04>
In-Reply-To: <1188482815.1131.374.camel@frg-rhel40-em64t-04>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xavier Bestel wrote:
> On Thu, 2007-08-30 at 15:55 +0200, Helge Hafting wrote:
>   
>> If the swap device is full, then there is no need for random
>> seeks as the swap pages can be read in disk order.
>>     
>
> If the swap file is full, you probably have a machine dead into a swap
> storm.
Only if you have enough swap. :-)

Helge Hafting
