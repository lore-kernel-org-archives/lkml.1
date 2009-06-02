Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601AbZFBNGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbZFBNGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 09:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbZFBNGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 09:06:06 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:46768 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbZFBNGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 09:06:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qfj+1UPqLhchnahFQa9Vn9BGncRe/EbFXKrhmNi2vHIEqDzZ92RfORep2WobL0JzOc
         WIW/u+Wn5tW4AMBmskGgGxSqI57cP13Lvqf9nCMmQqq1y4IL3u7C6F9fR20yBAOW+DC7
         vtsexjCbx1UBJoT2kbS4wbYgW7G7PZFVVQeZs=
Date: Tue, 2 Jun 2009 15:07:20 +0200
From: Bernhard Reutner-Fischer <rep.dot.nop@gmail.com>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Matt Mackall <mpm@selenic.com>, Sam Ravnborg <sam@ravnborg.org>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] update kernel's scripts/bloat-o-meter from busybox
Message-ID: <20090602130720.GA6259@mx.loc>
References: <200906011526.01108.rgetz@blackfin.uclinux.org> <1243885732.22069.112.camel@calx> <200906011657.20251.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906011657.20251.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 04:57:20PM -0400, Robin Getz wrote:
>On Mon 1 Jun 2009 15:48, Matt Mackall pondered:
>> On Mon, 2009-06-01 at 15:26 -0400, Robin Getz wrote:

>> > +	# Skip archive members
>> > +        if len(l.split()) == 1 and l.endswith(':'):
>> 
>> if ' ' not in l ...
>
>http://git.busybox.net/busybox/commit/?id=49bdf28c320bf4e02048eb0cbd115d84b8467cd9
>
>OK with me - if it is OK with Bernhard.

Fine with me either way, sure. All parts i ever touched in bloat-o-meter
(and kbuild, kconfig) are:
Signed-off-by: Bernhard Reutner-Fischer <rep.dot.nop@gmail.com>

thanks,
