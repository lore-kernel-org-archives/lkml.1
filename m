Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbXITAx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbXITAx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 20:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbXITAxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 20:53:22 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:12195 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbXITAxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 20:53:21 -0400
Date: Wed, 19 Sep 2007 18:51:11 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Out of socket memory
In-reply-to: <fa.3CwoTTQ1S/AhXEODsNaySgEYmWc@ifi.uio.no>
To: Ilya Eremin <che_guevara_3@bk.ru>
Cc: linux-kernel@vger.kernel.org
Message-id: <46F1C3FF.4030706@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.3CwoTTQ1S/AhXEODsNaySgEYmWc@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ilya Eremin wrote:
> Hello,
> 
> I am running a P2P related server, which has many connections to it at one time (about 100,000 at peak times). But I have been getting
> eserver invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0 errors followed by
> Out of socket memory
> I believe this is related to rmem, but I am not sure. Here's my current net related sysctl settings
> 
> net.core.wmem_max = 8388608
> net.core.rmem_max = 8388608
> net.core.wmem_default = 104448
> net.core.rmem_default = 104448

..

> 
> I am not sure if I should increase rmem further or not

Increasing that will likely make things worse, not better, as it allows 
more memory to be allocated for each socket. I should think you want to 
adjust those values down, not up..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

