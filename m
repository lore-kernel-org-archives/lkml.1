Return-Path: <linux-kernel-owner+w=401wt.eu-S1757765AbYLEOvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765AbYLEOvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 09:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbYLEOu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 09:50:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39584 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbYLEOu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 09:50:58 -0500
Message-ID: <49394096.6080402@redhat.com>
Date: Fri, 05 Dec 2008 09:54:14 -0500
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: linux-crypto@vger.kernel.org
CC: Neil Horman <nhorman@tuxdriver.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: des: fix inverted weak key flag check
References: <200812041555.22429.jarod@redhat.com>
In-Reply-To: <200812041555.22429.jarod@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> Based on the fact the testmgr code sets the weak key flag for
> vectors with wk = 1, the weak key flag check in des_setkey()
> is backwards. Also, add a warning when a weak key is rejected,
> otherwise you silently get a bogus result back.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Self-NAK. Due to mail server issues, this might show up before the 
original...

My understanding of the flag's meaning appears to be backwards, Herbert 
pointed out that the use of this flag is self-consistent. Also, the 
printk probably shouldn't be there, the caller should check retval and 
complain if need be.


-- 
Jarod Wilson
jarod@redhat.com
