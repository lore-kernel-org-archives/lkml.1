Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbZEFK5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbZEFK5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 06:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZEFK5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 06:57:43 -0400
Received: from web32603.mail.mud.yahoo.com ([68.142.207.230]:44044 "HELO
	web32603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752710AbZEFK5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 06:57:42 -0400
Message-ID: <834172.25385.qm@web32603.mail.mud.yahoo.com>
X-YMail-OSG: HenBl3cVM1lTRq6h._AmvWvRrt.cOM.PKB_DlksTQxgn5tqbIe2BE.5fvqQM097egLxwbl77q0of3SFontbBylVphVpnWuHcvXnnTGywkSveBOdbL2RQ5pSmw53HyqXtXGBxPnl3gx5uWBMvhsqom_OIzVjLaO1vqpQVZoGyqwtM.DzvLLW51NjUnYeTJpSlRS7lcGh7mzxnvkPEzkF1Ab1D4GkwBYyMJTv1LcOq0BtBa9WX0tCKd9QSQESXGeYo3ckGRtS5zVOrULRGVD0zQX3X.YbwKacYVueJWyWfyQrH1nERgyb.mPUzTpSJtZ8PC29njG.16T8gn5akKP0ZonLt
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.35 YahooMailWebService/0.7.289.1
References: <409142.83316.qm@web32605.mail.mud.yahoo.com>  <20090428182837.62c51f26.akpm@linux-foundation.org>  <1240977096.5478.3.camel@marge.simson.net>  <20090429011755.c141c599.akpm@linux-foundation.org>  <20090429120827.GI8633@ZenIV.linux.org.uk>  <1241014725.15095.19.camel@marge.simson.net>  <20090505154911.e0309a4f.akpm@linux-foundation.org>  <1241585140.5196.28.camel@marge.simson.net>  <957194.27869.qm@web32605.mail.mud.yahoo.com> <1241599065.18090.18.camel@marge.simson.net>
Date: Wed, 6 May 2009 03:57:42 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
To: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, viro@ZenIV.linux.org.uk,
       rjw@sisk.pl, linux-kernel@vger.kernel.org, tigran@aivazian.fsnet.co.uk
In-Reply-To: <1241599065.18090.18.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




 ------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de



----- Original Message ----
> From: Mike Galbraith <efault@gmx.de>
> To: Martin Knoblauch <knobi@knobisoft.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>; viro@ZenIV.linux.org.uk; rjw@sisk.pl; linux-kernel@vger.kernel.org; tigran@aivazian.fsnet.co.uk
> Sent: Wednesday, May 6, 2009 10:37:45 AM
> Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
> 
> On Wed, 2009-05-06 at 00:55 -0700, Martin Knoblauch wrote:
> 
> >  just to bring this back to my problem :-)
> 
> Good idea :-)
> 
> >  Last week I reported that the "new" sysfs entry in /proc/mounts already comes 
> out of initrd. Does this ring a bell?
> > 
> > http://lkml.indiana.edu/hypermail/linux/kernel/0904.3/03048.html
> 
> Nope, no bells.
> 
> The only thing I can suggest is that you try a bisection.
> 

 I was afraid that someone would bring up the bi-word :-) I am not using git so far, and my playground is behind a customers firewall.

 In a first attempt I tried to be "cheap" and look for the first rcX, but unfortunatelly the new behaviour already starts with 29-rc1 :-(

Cheers
Martin

