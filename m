Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbXCUPjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbXCUPjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932451AbXCUPjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:39:22 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:33584 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344AbXCUPjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:39:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QmPPdloUGHmADzn+sDn+4ZAhZ5IZA8EW5H/NO06RjJR2tu0s1C+3isoY7YIbLLrtu1Vz+zmd66V251kVJB0P4a2QPuaa1F6QV57ID5EbwJ7navfl/ZnfbpEpVdPEVoh6w1xguERDNPtw48R9X6wXWl3TQBL6ubA48usUqHgSmHI=
Message-ID: <8bd0f97a0703210839g6cabb2ccla11d0ec19f3d0810@mail.gmail.com>
Date: Wed, 21 Mar 2007 11:39:20 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>, "Wu, Bryan" <bryan.wu@analog.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Arnd Bergmann" <arnd@arndb.de>,
       "bert hubert" <bert.hubert@netherlabs.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/4] Blackfin: architecture update patch
In-Reply-To: <20070321125631.GA13192@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1174471618.5648.50.camel@roc-desktop>
	 <20070321125631.GA13192@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/07, Paul Mundt <lethal@linux-sh.org> wrote:
> On Wed, Mar 21, 2007 at 06:06:58PM +0800, Wu, Bryan wrote:
> > +++ linux-2.6/arch/blackfin/Kconfig   2007-03-21 14:38:42.000000000 +0800
> > +config BLACKFIN
> >  config BFIN
>
> Again, there's no reason to have both of these. Pick one and stick with
> it.

we're working on it ... not everything has been converted yet, thus
they're still both alive :/

> > +/* CSYNC implementation for C file */
> >  #if defined(ANOMALY_05000312) && defined(ANOMALY_05000244)
>
> Is there some reason these aren't config options? Perhaps an errata
> sub-menu might be more intuitive.

there is ... in the Kconfig, you select the CPU and the silicon
version ... we then have a header file that determines which anomalies
need to be worked around since the anomaly/silicon binding is static
-mike
