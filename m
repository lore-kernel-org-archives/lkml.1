Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbZBYO3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbZBYO3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 09:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758948AbZBYO3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 09:29:16 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:44853 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758246AbZBYO3O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 09:29:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PdDs8GdA540ztHFpIZ987SH3DANrzriIlN9Y9Cd5mN1Xv+lmOtwUymuLjp+9k9n9HL
         WfUP4eF8pLvj9Xl1/d6X68+4N6LqFhRKsuGY0z4DDalwkhN5wGqYmHoFnjFvqAsPZnmK
         e+9Stq8GXCOXkzCjdFHLnV+Q1KQeYRMdj5QwI=
MIME-Version: 1.0
In-Reply-To: <49A55499.6090700@suse.de>
References: <49A54C23.8090209@suse.de>
	 <20090225142000.GA4136@gondor.apana.org.au> <49A55499.6090700@suse.de>
Date: Wed, 25 Feb 2009 11:29:12 -0300
Message-ID: <82ecf08e0902250629n6a190165u557c21b0ebe797d5@mail.gmail.com>
Subject: Re: [PATCH][trivial] crypto: tcrypt - reduce stack size
From: Thiago Galesi <thiagogalesi@gmail.com>
To: Frank Seidel <fseidel@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-crypto@vger.kernel.org, Frank Seidel <frank@f-seidel.de>,
       akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
       nhorman@tuxdriver.com, lho@amcc.com, kaber@trash.net,
       darrenrjenkins@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 11:24 AM, Frank Seidel <fseidel@suse.de> wrote:
> Herbert Xu wrote:
>>> -    char output[1024];
>>
>> How about just making it static?
>
> Well, it was static before. But there
> are efforts to reduce current stack memory
> footprints.

If you write static char output[1024]; (even inside a function) it's
not allocated on the stack.

-- 
-
Thiago Galesi
