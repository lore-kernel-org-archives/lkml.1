Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbXELDVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbXELDVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 23:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbXELDV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 23:21:27 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:52908 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbXELDV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 23:21:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rBuoAnkP2NMUq5I2PEu37tNmlRI/qoF/Ui8J1hG2lBaouGzsjWkxk1eNC97qJTofAGAcZwYTQ2i+PwJJsLF4H8C7gPJrdM8hVEifykTRSqUeN8dSqa5zoj0m6ZhwU2W5ch1zVxcApHv6XLz8UWHBC8Whw3T4tGm+54Cua0sB/ac=
Message-ID: <a781481a0705112021u7b6d32fcxb6318d7e2443c970@mail.gmail.com>
Date: Sat, 12 May 2007 08:51:24 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jonathan Corbet" <corbet@lwn.net>
Subject: Re: [PATCH] "volatile considered harmful", take 3
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Johannes Stezenbach" <js@linuxtv.org>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Heikki Orsila" <shdl@zakalwe.fi>, "H. Peter Anvin" <hpa@zytor.com>,
       "jimmy bahuleyan" <knight.camelot@gmail.com>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>
In-Reply-To: <12700.1178905000@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12700.1178905000@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/11/07, Jonathan Corbet <corbet@lwn.net> wrote:
> Here's another version of the volatile document.  Once again, I've tried
> to address all of the comments.  There haven't really been any recent
> comments addressing the correctness of the document; people have been
> more concerned with how it's expressed.  I'm glad to see files in
> Documentation/ held to a high standard of writing, but, unless somebody
> has a factual issue this time around I would like to declare Mission
> Accomplished and move on.

The document looks good, but whether:

> +  - Pointers to data structures in coherent memory which might be modified
> +    by I/O devices can, sometimes, legitimately be volatile.  A ring buffer
> +    used by a network adapter, where that adapter changes pointers to
> +    indicate which descriptors have been processed, is an example of this
> +    type of situation.

is a legitimate use case for volatile is still not clear to me (I
agree with Alan's
comment in a previous thread that this seems to be a case where a memory
barrier would be applicable^Wbetter, actually). I could be wrong here, so
would be nice if Peter explains why volatile is legitimate here.

Otherwise, it's fine with me.

Thanks,
Satyam
