Return-Path: <linux-kernel-owner+w=401wt.eu-S1759785AbZD2Rp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785AbZD2Rp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 13:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756349AbZD2RpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 13:45:17 -0400
Received: from web32603.mail.mud.yahoo.com ([68.142.207.230]:41699 "HELO
	web32603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751604AbZD2RpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 13:45:16 -0400
Message-ID: <534170.5709.qm@web32603.mail.mud.yahoo.com>
X-YMail-OSG: nVbcAnAVM1kGgNCOitelz3Urz37.w5Wd7vMvI0exLzYFzVjRw8_BuOhW47ASQGWQbs.cqMd7wsyjuZeSJmJ9SI0F5FkJubZajJBW0bs0mWFGNLVtIQzGQLFAXZpM4UEXcGlnWb6q1Q.A8eEZmSj8_SSS5yhg2KtIHIBBb2GHYRSL5YkSLP6sDTJMHrmtWLF8fTUBA2YW2Z.3fNn5BXATdoRkgE6IOKHzmE1MvYvX6eTIKGaOQ8fFM2tL.IBiYdpDdzBTvo8e.0a7rgGLzLKJsTUMqI0jidFmk40BdqtTeVI0pFwcPd0-
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.35 YahooMailWebService/0.7.289.1
References: <409142.83316.qm@web32605.mail.mud.yahoo.com> <20090428182837.62c51f26.akpm@linux-foundation.org> <1240977096.5478.3.camel@marge.simson.net> <20090429011755.c141c599.akpm@linux-foundation.org> <20090429120827.GI8633@ZenIV.linux.org.uk>            <884894.99151.qm@web32602.mail.mud.yahoo.com> <30441.1241026559@turing-police.cc.vt.edu>
Date: Wed, 29 Apr 2009 10:45:15 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
To: Valdis.Kletnieks@vt.edu
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org,
       tigran aivazian <tigran@aivazian.fsnet.co.uk>
In-Reply-To: <30441.1241026559@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----

> From: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
> To: Martin Knoblauch <knobi@knobisoft.de>
> Cc: Al Viro <viro@ZenIV.linux.org.uk>; Andrew Morton <akpm@linux-foundation.org>; Mike Galbraith <efault@gmx.de>; Rafael J. Wysocki <rjw@sisk.pl>; linux-kernel@vger.kernel.org; tigran aivazian <tigran@aivazian.fsnet.co.uk>
> Sent: Wednesday, April 29, 2009 7:35:59 PM
> Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
> 
> On Wed, 29 Apr 2009 10:24:20 PDT, Martin Knoblauch said:
> 
> >  One definitely comes from /etc/fstab, but I am not aware of any other script
> mounting sysfs in my userspace.
> 
> You said it was a RedHat box?
> 
> Look in /etc/rc.sysinit:
> 
>         mount -n -t sysfs /sys /sys >/dev/null 2>&1
> 
> (Near line 28 for RHEL 4, line 23 for RHEL5, and line 21 for Fedora Rawhide)
> 
> Probably your culprit.

 OK, you got me. But still something changed with 2.6.29. Before, there was only one line in /proc/mounts

Cheers
Martin

