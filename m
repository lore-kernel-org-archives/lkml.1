Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbZBYOeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbZBYOeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 09:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbZBYOeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 09:34:15 -0500
Received: from ns2.suse.de ([195.135.220.15]:34917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbZBYOeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 09:34:14 -0500
Message-ID: <49A556E3.1000309@suse.de>
Date: Wed, 25 Feb 2009 15:34:11 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Thiago Galesi <thiagogalesi@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-crypto@vger.kernel.org, Frank Seidel <frank@f-seidel.de>,
       akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
       nhorman@tuxdriver.com, lho@amcc.com, kaber@trash.net,
       darrenrjenkins@gmail.com, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH][trivial] crypto: tcrypt - reduce stack size
References: <49A54C23.8090209@suse.de>	 <20090225142000.GA4136@gondor.apana.org.au> <49A55499.6090700@suse.de> <82ecf08e0902250629n6a190165u557c21b0ebe797d5@mail.gmail.com>
In-Reply-To: <82ecf08e0902250629n6a190165u557c21b0ebe797d5@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thiago Galesi wrote:
> If you write static char output[1024]; (even inside a function) it's
> not allocated on the stack.

Oh, yes i misunderstood Herbert, sorry. But anyway isn't
it preferred to kmalloc such arrays?
Greg, i thought it was you who told me so, is that right?

Thanks,
Frank

