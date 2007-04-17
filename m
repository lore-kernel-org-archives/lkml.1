Return-Path: <linux-kernel-owner+w=401wt.eu-S1031142AbXDQQSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031142AbXDQQSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 12:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031144AbXDQQSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 12:18:44 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:50382 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031142AbXDQQSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 12:18:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=e7OYmRBkfOyBuwSsaISZpQDW+cPAxbb8qlSmjbR1zeA2TB471R/tokSzqk7kAEV7XCYFqnaIKBLyrRohBlCRqNXGz49d/P+XXMAKgczpOKlXllUhMvb3RNMTrz/Xyqs/L0B3Vo/Ro7k2jH7jA7JZEIgAOECG3S2GySpq8Iwzy64=
Message-ID: <38b2ab8a0704170918u72792c0ei591fea98eac2681d@mail.gmail.com>
Date: Tue, 17 Apr 2007 18:18:42 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: [CRYPTO] is it really optimized ?
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, helge.hafting@aitel.hist.no,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <20070417155725.GA18959@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070417130431.GA8685@2ka.mipt.ru>
	 <E1HdnwX-0005U1-00@gondolin.me.apana.org.au>
	 <38b2ab8a0704170701p69fd547dwe3e2523ba5798b55@mail.gmail.com>
	 <20070417150859.GA9512@2ka.mipt.ru>
	 <38b2ab8a0704170834i1856886nafeeec692f49fea0@mail.gmail.com>
	 <20070417155725.GA18959@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/17/07, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
>
> If there are another users, then flag should not be set.

depends if there's a 'generic' algo that can be used at the same time.
Admin should know that.

> If there are no another users, your code already has exclusive access.

sorry I don't understand that.

> One can not know if there will be any additional users at all (consider
> the case when new encrypted block device or ipsec negotiation started
> some time after module was loaded).
>

well I should say administrator should know.

-- 
Francis
