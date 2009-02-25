Return-Path: <linux-kernel-owner+w=401wt.eu-S1757711AbZBYOZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711AbZBYOZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 09:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbZBYOYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 09:24:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:34703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513AbZBYOYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 09:24:49 -0500
Message-ID: <49A55499.6090700@suse.de>
Date: Wed, 25 Feb 2009 15:24:25 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux kernel <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
       Frank Seidel <frank@f-seidel.de>, akpm@linux-foundation.org,
       "David S. Miller" <davem@davemloft.net>, nhorman@tuxdriver.com,
       lho@amcc.com, kaber@trash.net, darrenrjenkins@gmail.com
Subject: Re: [PATCH][trivial] crypto: tcrypt - reduce stack size
References: <49A54C23.8090209@suse.de> <20090225142000.GA4136@gondor.apana.org.au>
In-Reply-To: <20090225142000.GA4136@gondor.apana.org.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
>> -	char output[1024];
> 
> How about just making it static?

Well, it was static before. But there
are efforts to reduce current stack memory
footprints.

Frank

