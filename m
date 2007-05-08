Return-Path: <linux-kernel-owner+w=401wt.eu-S934507AbXEHICZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934507AbXEHICZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 04:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934397AbXEHICU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 04:02:20 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:34046 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934012AbXEHICR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 04:02:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=l6fhotekRi4QMAVCGgjt8UnDhmzQOvJNoePpBCJKo1+pxX0viK7w6LfOMbInFVOE3v8llkv66D4zuNM4LP0c4CZYC/oUk31r9RZUqQoAQBJInLiE7i9Wv/PYfXPkXdBn2Rn3aD9ovjySwVbk+X2UW7/C9tg2z0VBEtzuqaLU4nU=
Message-ID: <46402E7B.8090702@gmail.com>
Date: Tue, 08 May 2007 10:02:03 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: William Thompson <wt@electro-mechanical.com>
CC: Jeff Garzik <jgarzik@pobox.com>, Mark Lord <liml@rtr.ca>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       albertcc@tw.ibm.com
Subject: Re: [PATCH] libata: fallback to the other IDENTIFY on device error
References: <20070427175205.GD7809@electro-mechanical.com> <4635C35D.1020807@gmail.com> <20070430202107.GF5942@electro-mechanical.com> <4636C2C7.8090206@gmail.com> <20070501121703.GH5942@electro-mechanical.com> <46373AEE.6070908@rtr.ca> <20070501131818.GA18521@electro-mechanical.com> <46374354.7040307@gmail.com> <20070501172117.GA20328@electro-mechanical.com> <463F56F2.3010106@gmail.com> <20070507180547.GB4215@electro-mechanical.com>
In-Reply-To: <20070507180547.GB4215@electro-mechanical.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Thompson wrote:
> On Mon, May 07, 2007 at 06:42:26PM +0200, Tejun Heo wrote:
>> It seems the world isn't as frank as we thought and some devices lie
>> about who they are.  Fallback to the other IDENTIFY if IDENTIFY fails
>> with device error.  As this is the strategy used by IDE for a long
>> time, it shouldn't cause too much problem.
>>
>> Signed-off-by: Tejun Heo <htejun@gmail.com>
>> Cc: William Thompson <wt@electro-mechanical.com>
>> ---
>> Willam, please verify this fixes your problem.  Jeff, after all, we
>> seem to need this.  :-(
> 
> Even though you have a different libata-core.c than I, the patch does work!

The different part is in libata devel tree and the rejection at the
variable declaration doesn't matter as long as you add the variable.
Thanks for testing.  :-)

-- 
tejun
