Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbYGaG1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbYGaG1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 02:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYGaG1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 02:27:25 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:19585 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbYGaG1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 02:27:24 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-2.tower-164.messagelabs.com!1217485642!8216654!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Thu, 31 Jul 2008 08:27:18 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Adrian Bunk <bunk@kernel.org>, Matthew Wilcox <matthew@wil.cx>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "mpm@selenic.com" <mpm@selenic.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [patch 2/4] Configure out file locking features
Message-ID: <20080731062718.GA25325@digi.com>
References: <20080729154520.728594017@free-electrons.com> <20080729154747.872888047@free-electrons.com> <20080729181751.GA24924@parisc-linux.org> <20080730142754.GD19966@cs181140183.pp.htv.fi> <20080730174028.67184ea2@surf>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080730174028.67184ea2@surf>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 31 Jul 2008 06:27:19.0512 (UTC) FILETIME=[7BDDDD80:01C8F2D6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

Thomas Petazzoni wrote:
> Le Wed, 30 Jul 2008 17:27:54 +0300,
> Adrian Bunk <bunk@kernel.org> a écrit :
> 
> > It seems the emails containing the patches never made it to the vger 
> > lists, which makes it a bit hard to comment on them.
> 
> Yes, they didn't make it to the lists, for some reason. Maybe it's
> because I sent them using "quilt mail --send", which uses my local
> exim4 mail server, and for some reason, vger doesn't like that kind of
> e-mails. However, my exim4 is configured to sent the e-mails through by
> ISP SMTP. From my exim4 mainlog:
> 
> 2008-07-29 17:47:57 1KNrQS-0007kt-Kg => linux-kernel@vger.kernel.org R=smarthost T=remote_smtp_smarthost H=smtp.free.fr [212.27.48.4]*
> 2008-07-29 17:47:57 1KNrQS-0007kt-Kg -> linux-embedded@vger.kernel.org R=smarthost T=remote_smtp_smarthost H=smtp.free.fr [212.27.48.4]*
> 2008-07-29 17:47:57 1KNrQS-0007kt-Kg -> netdev@vger.kernel.org R=smarthost T=remote_smtp_smarthost H=smtp.free.fr [212.27.48.4]*
> 2008-07-29 17:47:57 1KNrQS-0007kt-Kg -> davem@davemloft.net R=smarthost T=remote_smtp_smarthost H=smtp.free.fr [212.27.48.4]*
> 2008-07-29 17:47:57 1KNrQS-0007kt-Kg -> mpm@selenic.com R=smarthost T=remote_smtp_smarthost H=smtp.free.fr [212.27.48.4]*
> 2008-07-29 17:47:57 1KNrQS-0007kt-Kg -> akpm@linux-foundation.org R=smarthost T=remote_smtp_smarthost H=smtp.free.fr [212.27.48.4]*
> 2008-07-29 17:47:57 1KNrQS-0007kt-Kg -> thomas.petazzoni@free-electrons.com R=smarthost T=remote_smtp_smarthost H=smtp.free.fr [212.27.48.4]*
> 2008-07-29 17:47:57 1KNrQS-0007kt-Kg -> michael@free-electrons.com R=smarthost T=remote_smtp_smarthost H=smtp.free.fr [212.27.48.4]*
> 2008-07-29 17:47:57 1KNrQS-0007kt-Kg Completed
> 
> So from my side, everything seemed to work well. Does anybody has a
> clue ?
Don't know if this is the problem, but I had problems getting mails
through some time ago, too.  For me the problem was that the source
address was myusername@mymachine.intranet.$mycompany.$tld and
vger.kernel.org didn't want to take these because the host name had no
DNS entry.

I fixed that by rewriting the From line in outgoing mails on my host.
I'm using postfix (from Debian) so I had to add an entry to
/etc/postfix/sender_canonical.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
