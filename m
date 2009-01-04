Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbZADBgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbZADBgg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 20:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbZADBgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 20:36:10 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41301
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZADBgJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 20:36:09 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH 1/3]: Replace kernel/timeconst.pl with kernel/timeconst.sh
Date: Sat, 3 Jan 2009 19:36:04 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net> <200901020213.30658.rob@landley.net> <200901031328.23079.ioe-lkml@rameria.de>
In-Reply-To: <200901031328.23079.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200901031936.04642.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009 06:28:22 Ingo Oeser wrote:
> > +for i in "MSEC 1000" "USEC 1000000"
> > +do
> > +	NAME=$(echo $i | awk '{print $1}')
>
> cut -d' ' -f1  does the same
>
> > +	PERIOD=$(echo $i | awk '{print $2}')
>
> cut -d' ' -f2  does the same

>From a standards perspective 
http://www.opengroup.org/onlinepubs/9699919799/utilities/cut.html vs 
http://www.opengroup.org/onlinepubs/9699919799/utilities/awk.html is probably 
a wash, but from a simplicity perspective using the tool that _isn't_ its own 
programming language is probably a win. :)

I made the change in the second round of patches I just posted.

Thanks,

Rob
