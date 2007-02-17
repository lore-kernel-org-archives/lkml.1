Return-Path: <linux-kernel-owner+w=401wt.eu-S932730AbXBQStw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730AbXBQStw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 13:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932731AbXBQStw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 13:49:52 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:54521 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730AbXBQStv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 13:49:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qjbPzbRChoV4l8JVrebsqj9gwwgZy5lbarMNeQXVGGUI22QExdcThJN14Bx4TgCxNf1zbRmmo1Qhbi3xyLCu4QSB4lsNUK/kGl5ClZtQ0/l4gLCTlkzX49N4wBwIBVJflbABBFUeMAth9JOrMj3aLPQYXC95HaQk+z/DZqv6r7s=
Message-ID: <edd3ff190702171049q3530d444k292e61acae802c68@mail.gmail.com>
Date: Sat, 17 Feb 2007 19:49:50 +0100
From: "=?ISO-8859-1?Q?Daniel_Aragon=E9s?=" <danarag@gmail.com>
To: "=?ISO-8859-1?Q?C=E9dric_Augonnet?=" <cedric.augonnet@gmail.com>
Subject: Re: 2.6.20-mm1 - Oops using Minix 3 file system
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Cedric.augonnet@ens-lyon.org
In-Reply-To: <f56c1ba00702170953l5dd4ea75ga2ae1e6d069e9f7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <f56c1ba00702161500x775fe04bl91889b5819cf9ddc@mail.gmail.com>
	 <edd3ff190702170255w1c30fa08v96e5b92baacbd701@mail.gmail.com>
	 <f56c1ba00702170551k7cbbf79dkfc550e3d4b387d4c@mail.gmail.com>
	 <edd3ff190702170844q120c5f92l6c7c385665048c16@mail.gmail.com>
	 <f56c1ba00702170953l5dd4ea75ga2ae1e6d069e9f7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/17/07, Cédric Augonnet <cedric.augonnet@gmail.com> wrote:

>
> Well i actually do access to this partition, i can edit it and use it,
> this on Linux. Sorry if this is not clear.
>

Here is the point, I think. I'm afraid that you don't really access
any *real* partition. If it were so, that partition would have an
identifying *device* name. You access something within an image for an
emulating program that you interpret as a partition but not the
kernel. So it cannot access the superblock of it in its buffer and
recover bh->b_size to go on properly. It recovers something else. And
this triggers the oops.

Regards,

Daniel
