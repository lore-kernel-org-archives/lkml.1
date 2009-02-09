Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbZBIFu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbZBIFu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 00:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbZBIFuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 00:50:20 -0500
Received: from nn7.de ([85.214.94.156]:33775 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbZBIFuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 00:50:19 -0500
Subject: Re: [Bug #12613] [Suspend regression][DRM, RADEON]
From: Soeren Sonnenburg <kernel@nn7.de>
To: etienne <etienne.basset@numericable.fr>
Cc: "Rafael J\. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>
In-Reply-To: <498F5785.3000009@numericable.fr>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
	 <sWhNs83kKPE.A.HiF.r20jJB@chimera>  <498F5785.3000009@numericable.fr>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 09 Feb 2009 06:50:09 +0100
Message-Id: <1234158609.3821.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-08 at 23:07 +0100, etienne wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12613
> > Subject		: [Suspend regression][DRM, RADEON]
> > Submitter	: etienne <etienne.basset@numericable.fr>
> > Date		: 2009-01-28 22:00 (12 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a9d51a5ad1154b5b20add1e8d30a5564f8aabbe9
> > References	: http://marc.info/?l=linux-kernel&m=123318030419558&w=4
> > 		  http://marc.info/?l=linux-kernel&m=123334865404574&w=4
> >
> >
> >   
> hello,
> yes it's still present in -rc4
> But I noticed that when I switch off KDE4.2 desktop effects, suspend to 
> ram is 100% reliable with 2.6.29-rc4
> With 2.6.28, STR is 100% reliable with or without desktop effects

For me it is reliable as soon as compositing/dri is disabled on 2.6.29.
On 2.6.28 it worked with compositing/dri *sometimes* - so 2.6.29 is the
first reliable kernel for me (when not using 3d).

Soeren
