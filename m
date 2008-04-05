Return-Path: <linux-kernel-owner+w=401wt.eu-S1752636AbYDEMpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbYDEMpO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 08:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbYDEMpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 08:45:00 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51250
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbYDEMpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 08:45:00 -0400
Message-ID: <47F77431.3030608@qumranet.com>
Date: Sat, 05 Apr 2008 15:44:33 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Max Krasnyansky <maxk@qualcomm.com>,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC 2/5] vringfd base/offset
References: <200804052202.09157.rusty@rustcorp.com.au> <200804052204.28518.rusty@rustcorp.com.au>
In-Reply-To: <200804052204.28518.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> It turns out the lguest (and possibly kvm) want the addresses in the
> ring buffer to only cover a certain part of memory, and be offset.
>
>  					<mailto:rusty@rustcorp.com.au>	
> +0xAE	00-01	linux/vring.h
>   

Another virtualization subsystem already uses this range.


-- 
Any sufficiently difficult bug is indistinguishable from a feature.

