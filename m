Return-Path: <linux-kernel-owner+w=401wt.eu-S932798AbXB0GVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798AbXB0GVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 01:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932817AbXB0GVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 01:21:22 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:19966 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798AbXB0GVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 01:21:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=GyaxNnUlqQrTqYvtlNDsRqpVbifxEld8t53ypaXBZGbg9h3ls2LhOVuaqp0/1Z6+QB+2fm6sbGWaC+teq0hpLWsybdeLO6cw45DU7Li90Lf82wiwps3k/R3lW7/h6WkliYF6XJhCYHdqkE6wLeavfWygrpqwbKh8ef7KZRwx1eI=
Message-ID: <e9c3a7c20702262221i4ce5d2c8r4f55ee70d04c7a70@mail.gmail.com>
Date: Mon, 26 Feb 2007 23:21:19 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: [RFC] div64_64 support
Cc: "Jan Engelhardt" <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, "Nicolas Pitre" <nico@cam.org>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>
In-Reply-To: <20070226143127.5c74bec9@freekitty>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070223170527.4ca695b2@freekitty>
	 <Pine.LNX.4.61.0702262108010.23355@yvahk01.tjqt.qr>
	 <20070226143127.5c74bec9@freekitty>
X-Google-Sender-Auth: 5640421ebc786cd3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/26/07, Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> Here is another way to handle the 64 bit divide case.
> It allows full 64 bit divide by adding the support routine
> GCC needs.
>
<snip>

I know ARM already went through the process of removing __udivdi3 support:
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=2723/2

Copying Russell and Nicolas as a heads up.

--
Dan
