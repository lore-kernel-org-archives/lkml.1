Return-Path: <linux-kernel-owner+w=401wt.eu-S1752052AbZLWHe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbZLWHe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 02:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbZLWHe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 02:34:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:59980 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbZLWHe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 02:34:56 -0500
Message-ID: <4B31C8EE.3030003@kernel.org>
Date: Wed, 23 Dec 2009 16:38:22 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Cengiz Gunay <cgunay@emory.edu>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: sata_nv times out for BD-ROM iHOS104-08
References: <Pine.LNX.4.64.0912221105010.5876@stg.biology.emory.edu>
In-Reply-To: <Pine.LNX.4.64.0912221105010.5876@stg.biology.emory.edu>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/23/2009 01:07 AM, Cengiz Gunay wrote:
> I was unable to get another driver like the SATA AHCI or one of the PATA 
> drivers to take over this device. Is that even possible?

No.

> I would appreciate any suggestions and would happily debug this a little 
> further. And, of course, happy holidays everybody. Details of my 
> configuration follow.

Can you please try kernel parameter irqpoll?  Also, does having a
readable media in the drive during boot make any difference?

Thanks.

-- 
tejun
