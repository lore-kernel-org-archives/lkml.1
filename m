Return-Path: <linux-kernel-owner+w=401wt.eu-S1761146AbZANVx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761146AbZANVx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757385AbZANVxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:53:18 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:38296 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbZANVxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:53:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=j6fRnwuejNGt4y9kAQTwihEaW6NCznb2acWksqw0dP0FVeWRuNIpir2TJ4RPr9/SQO
         GjIBeqKCeShSBBBSV6lCZiFvd69JwPpYEjH/7nan6jixAYMdAtUEGv0zcuoVnrxPiyV5
         odQieycqKEAtUd9ZaFCN+V/WGLYDxcahSLGo0=
Message-ID: <3e8340490901141353u3990148ft1b20220a8317f7dc@mail.gmail.com>
Date: Wed, 14 Jan 2009 16:53:16 -0500
From: "Bryan Donlan" <bdonlan@gmail.com>
To: "Evgeniy Polyakov" <zbr@ioremap.net>
Subject: Re: [take2] OOM documentation update [was: Linux killed Kenny, bastard!]
Cc: linux-kernel@vger.kernel.org, "David Rientjes" <rientjes@google.com>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Dave Jones" <davej@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Theodore Tso" <tytso@mit.edu>,
       "Matthias Andree" <matthias.andree@gmx.de>
In-Reply-To: <20090114170606.GB12102@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090112155108.2646b3ae@lxorguk.ukuu.org.uk>
	 <20090113140627.507f15e1@lxorguk.ukuu.org.uk>
	 <20090113142423.GA30710@ioremap.net>
	 <661de9470901130700m34c4938cm6feeb6fc561d605a@mail.gmail.com>
	 <20090113152106.GA1134@ioremap.net>
	 <alpine.DEB.2.00.0901131140340.8522@chino.kir.corp.google.com>
	 <20090113213316.GB27227@ioremap.net>
	 <alpine.DEB.2.00.0901131336040.17683@chino.kir.corp.google.com>
	 <20090114161225.GA9584@ioremap.net>
	 <20090114170606.GB12102@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 12:06 PM, Evgeniy Polyakov <zbr@ioremap.net> wrote:

> + * resulted score is multiplied by the two in the power of oom_adj when it is
> +       positive, and divided otherwise, i.e.
> +       points <<= oom_adj when it is positive and
> +       points >>= oom_adj otherwise

Two to the power of a negative number is equivalent to dividing by two
to the power of said exponent's absolute value, making this paragraph
more than a bit confusing - indeed, a literal read would make it
equivalent to multiplying by 2^abs(oom_adj).

I would think that the following would be enough:
* The resulting score is multiplied by two to the power of oom_adj.

Unless we assume admins don't know how exponentiation by a negative
number works :)
