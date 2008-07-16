Return-Path: <linux-kernel-owner+w=401wt.eu-S1759391AbYGPK23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbYGPK23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 06:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbYGPK2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 06:28:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:58682 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301AbYGPK2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 06:28:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pFBAalO406xr2Pxs7X9GcMlFMIih91BulXVfax7Vu8DotgXT82OMGaJu0JJoHyWOJ5
         hlVVPUFKEuf6qEE58W7PW/CFuW5iWmwS4Gsxcgju2uUZT0i4yOhuq/+CD0Z0PSgjCo4i
         1uZPCzED0quxrQrbDRuuJ5Tn3I0CaX2j3X3VY=
Message-ID: <520f0cf10807160328m68c9bd92h9951322ec0ca8ecc@mail.gmail.com>
Date: Wed, 16 Jul 2008 12:28:19 +0200
From: "John Kacur" <jkacur@gmail.com>
To: "Jan Engelhardt" <jengelh@medozas.de>
Subject: Re: Make the git URL match usage
Cc: "Bodo Eggert" <7eggert@gmx.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.1.10.0807161205220.26724@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <aQ9CN-4cK-11@gated-at.bofh.it>
	 <E1KJ3Ex-0001LD-Ub@be1.7eggert.dyndns.org>
	 <alpine.LNX.1.10.0807161205220.26724@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 12:06 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
> On Wednesday 2008-07-16 10:54, Bodo Eggert wrote:
>
>>jkacur <jkacur@gmail.com> wrote:
>>
>>> Subject: Make the git URL match the usage
>>> Change the MAINTAINERS file so that the git URL reads EXACTLY the way someone
>>> would use it.
>>
>>> +++ linux-2.6.26/MAINTAINERS
>>
>>> +T:   git://git.kernel.org:/pub/scm/linux/kernel/ericvh/v9fs.git
>>                            ^^
>
> There is more brokenness in this patch. That URL (even without ':')
> gives 404.
> Here is a clueful hint...
>
> -git://git.kernel.org/pub/scm/linux/kernel/ericvh/v9fs.git
> +git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git
>
> Check the URLs before modifying them.
>

Hmnn, ok, that is what happens when you try to fix what looks like a
simple problem that occurs to you in one context for everyone else in
a mechanical way. Thanks for pointing it out, this time I will
carefully go through every URL and check them before modifying so,
give me a little bit of time before I send out a refreshed patch, I
wanted to do it right this time.
