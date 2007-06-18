Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbXFRG2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbXFRG2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 02:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbXFRG2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 02:28:12 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:21008 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbXFRG2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 02:28:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZXfL2LA1ktLlvRKMeB/anASE/mZUAofMP3tXSsqkwzkyStQ+77dLMNCWAznC8FgNLqVFYTgR96EwFKAKyhuy4TszFEY5xlsYcyLq/O4pE1HOo2NKcyhaPl8XoZjKQj3Pv6baApnZTXKK2EYE2MOHWtQpBYDWwBLEjXqT9rx+T7E=
Message-ID: <8bd0f97a0706172328y1e433ea7gc5c10080f8950770@mail.gmail.com>
Date: Mon, 18 Jun 2007 02:28:10 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch] make hdrscheck.sh force __asm__ in exported headers
Cc: "Mike Frysinger" <vapier@gentoo.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070617223436.2125b1a4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706171854.24763.vapier@gentoo.org>
	 <20070617221140.f1564f92.akpm@linux-foundation.org>
	 <200706180117.46809.vapier@gentoo.org>
	 <20070617223436.2125b1a4.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 18 Jun 2007 01:17:46 -0400 Mike Frysinger <vapier@gentoo.org> wrote:
> > On Monday 18 June 2007, Andrew Morton wrote:
> > > And does the kernel pass these checks?
> >
> > nope ... should i audit the arches before this gets merged ?
>
> Yes please.  I'd rather not break things in this fashion: it causes a storm
> of emails which I need to redirect to the appropriate maintainers who then
> take an arbitrarily long time to do anything.  Meanwhile lots of testers
> get impacted and this reduces the testing level of all the other thousands
> of patches in there.

with the few patches i just sent out, the following pass:
alpha arm avr32 blackfin i386 ia64 m68k mips powerpc s390 sh sparc x86_64

cris and parisc fail vanilla git regardless
-mike
