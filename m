Return-Path: <linux-kernel-owner+w=401wt.eu-S932103AbXIIOM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbXIIOM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 10:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756448AbXIIOMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 10:12:49 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:29421 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237AbXIIOMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 10:12:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=k+vGPb1Y7YeWMkuenRrEG/J+n7qkLtFv4H6u2gOmCnDeNBZQXpQhvO1Fq9KqWxpL37N1zLHArbgjv0bNJWRK+x+wjQ2hlzaryYCKYv8CgbV9k7q9s/bjqyg1XpdjfALsAk82d1C7nSfPBvNqzaz5cZL8dojfeP31wU1P9dIHdfk=
Message-ID: <46E3FF5A.408@gmail.com>
Date: Sun, 09 Sep 2007 16:12:42 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH 1/2] remove asm/bitops.h includes
References: <30483262301654323266@pripojeni.net> <p738x7gs1rq.fsf@bingen.suse.de>
In-Reply-To: <p738x7gs1rq.fsf@bingen.suse.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2007 10:04 AM, Andi Kleen wrote:
> Jiri Slaby <jirislaby@gmail.com> writes:
> 
>> remove asm/bitops.h includes
>>
>> including asm/bitops directly may cause compile errors. 
> 
> When does it cause compile errors? It would be probably less 
> intrusive to just fix that case.

On ppc defconfig build, IIRC, the result is unpredictable (it can still occur in
some specific configurations) if it is not changed all, I think. But if
everybody agrees, I can fix only the ppc build.

thanks.
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
