Return-Path: <linux-kernel-owner+w=401wt.eu-S2993186AbXDSItS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993186AbXDSItS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 04:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993185AbXDSItS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 04:49:18 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:8451 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161309AbXDSItQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 04:49:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=h196Fcfm00kWKOpqt6mVLgoI9l+8ZloJOmX0FphN3FhWli1PdyHABz4stu+nqsRrCk/St4WBFEGSQLR0UnX4dksVgsFbemXf8Xj52N7b4S5o3Unkr7sRGuiENw48VkYew/waVX4G/qMD0OQRZPQ9o5jkFkzepKGjXhpqUp3k3O0=
Message-ID: <19061b0b0704190149j5057a89drb48664bb48110dd3@mail.gmail.com>
Date: Thu, 19 Apr 2007 10:49:16 +0200
From: Bartek <poemann@gmail.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: kernel BUG at net/core/skbuff.c in linux-2.6.21-rc6
Cc: "Paul Mackerras" <paulus@samba.org>, davem@davemloft.net, kaber@trash.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <E1HeHoZ-0000Y6-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <17953.30429.220756.818283@cargo.ozlabs.ibm.com>
	 <E1HeHoZ-0000Y6-00@gondolin.me.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Your fix is probably needed too.  However, I think the issue that Patrick
> was trying to fix is the case where p[0] != PPP_ALLSTATIONS and therefore
> we'd still have a problem there.

I tested Paul's patch for last few days and I think everything seems
ok. The system is stable.

Regards
Bartek
