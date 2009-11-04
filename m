Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbZKDASn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbZKDASn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 19:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbZKDASm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 19:18:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44056
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753296AbZKDASl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 19:18:41 -0500
Date: Tue, 03 Nov 2009 16:19:06 -0800 (PST)
Message-Id: <20091103.161906.261075602.davem@davemloft.net>
To: James.Bottomley@suse.de
Cc: roel.kluin@gmail.com, linux-scsi@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qlogicpti: add missing parentheses
From: David Miller <davem@davemloft.net>
In-Reply-To: <1257292309.2454.54.camel@mulgrave.site>
References: <4AF0BF04.9030203@gmail.com>
	<1257292309.2454.54.camel@mulgrave.site>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@suse.de>
Date: Tue, 03 Nov 2009 17:51:49 -0600

> On Wed, 2009-11-04 at 00:38 +0100, Roel Kluin wrote:
>> `+' has a higher precedence than `?' so the condition always
>> evaluates to true and this is preprocessed to `7*((ql) - 1)'
>> 
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>> ---
>>  drivers/scsi/qlogicpti.h |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> This one must be right, I think.
> 
> It looks plausible ... but it will increase the mailbox segment length
> by 4 ... someone needs to verify that this increase will actually work
> and won't run off the end of the mailbox table.

It should be fine, good find Roel.

Acked-by: David S. Miller <davem@davemloft.net>
