Return-Path: <linux-kernel-owner+w=401wt.eu-S1759520AbYHOQol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520AbYHOQol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 12:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbYHOQoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 12:44:32 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:16112 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbYHOQob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 12:44:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=kVPJcwWavjVZ2D0CX1LLNWuoiu4NvzgvftB3fAXRPgEmWEPuiWTx/RX7upo4TSJdik
         /TdVymCYsWXS1Nl1a5Rq2XABUfy507YqPMfJGuFo461RL/6notcCkNDluO7xVIysteKI
         86LVTmtDz1XPGuOCMFzQJE/6TlcLKDHPmUxSk=
Message-ID: <2f11576a0808150944g678f1b8di1c4d50de7358b306@mail.gmail.com>
Date: Sat, 16 Aug 2008 01:44:29 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Christoph Lameter" <cl@linux-foundation.org>
Subject: Re: No, really, stop trying to delete slab until you've finished making slub perform as well
Cc: "Matthew Wilcox" <matthew@wil.cx>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, "Mel Gorman" <mel@skynet.ie>,
       andi@firstfloor.org, "Rik van Riel" <riel@redhat.com>
In-Reply-To: <48A48B00.1090703@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080805210125.A897.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <48986AC6.5030406@linux-foundation.org>
	 <20080813194222.E77F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <48A2DD2C.3090602@linux-foundation.org>
	 <2f11576a0808130714k2cd031c4nd6eea3506831cac9@mail.gmail.com>
	 <48A2F030.9080301@linux-foundation.org>
	 <2f11576a0808130805s6963e2a4mbb82ad7221cf80a2@mail.gmail.com>
	 <48A48B00.1090703@linux-foundation.org>
X-Google-Sender-Auth: b6d16aa97793f64f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is a NUMA system right?

True.
My system is

CPU: ia64 x8
MEM: 8G (4G x 2node)

> Then we have another mechanism that will avoid
> off node memory references by allocating new slabs. Can you set the
> node_defrag parameter to 0? (Noted by Adrian).

Please let me know that operations ?
