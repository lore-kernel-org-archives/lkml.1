Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238AbYI3Ljq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbYI3Ljq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 07:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbYI3Lji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 07:39:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752288AbYI3Lji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 07:39:38 -0400
Message-ID: <48E20F98.4010106@linux-foundation.org>
Date: Tue, 30 Sep 2008 06:38:00 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, rusty@rustcorp.com.au, jeremy@goop.org,
       ebiederm@xmission.com, travis@sgi.com, herbert@gondor.apana.org.au,
       xemul@openvz.org
Subject: Re: [patch 3/4] cpu alloc: The allocator
References: <20080929193500.470295078@quilx.com>	 <20080929193516.278278446@quilx.com> <1222756559.10002.23.camel@penberg-laptop>
In-Reply-To: <1222756559.10002.23.camel@penberg-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:

>> +/*
>> + * Basic allocation unit. A bit map is created to track the use of each
>> + * UNIT_SIZE element in the cpu area.
>> + */
>> +#define UNIT_TYPE int
>> +#define UNIT_SIZE sizeof(UNIT_TYPE)
>> +
>> +int units;	/* Actual available units */
> 
> What is this thing? Otherwise looks good to me.

This is the number of units available from the cpu allocator. Its determined
on bootup and the bitmap is sized correspondingly.




