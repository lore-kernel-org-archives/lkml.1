Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbZEUCI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbZEUCI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 22:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbZEUCIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 22:08:52 -0400
Received: from n9.bullet.mail.mud.yahoo.com ([209.191.86.157]:28402 "HELO
	n9.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753814AbZEUCIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 22:08:51 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 May 2009 22:08:51 EDT
X-Yahoo-Newman-Id: 384892.28731.bm@omp401.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GiVkGpkmpS9EbH1R7uc8IB+zqWkRPsz2249gKzVqtVB82/TtvvoHc8RsaVQr/dG99dn8xliL8q2r4toLzjCuG/O6b94ThH3IkrGtlFJgRHBwVyOQnahB4dLzQdGXBEbDcSuPmWN9YZ8NN1nc6CNniMLznQhGApNydStj2nGpDlY=  ;
X-YMail-OSG: 3Ew7lVoVM1mIJQgIg7jMOKEtyUBkNRlR5bFjVwoE4w2O.H_rXvjJy7Umo9KFS40gpvt46j4wl8chHi09VtGVO.ZVXrwcyZKhpUwEWb.FRHsG5sb2tD4dEx86.ilGjsMAXhKk3MPCavWzHTQvJntWOL_HpRjbRcnBlgYZlmJJL5PZtKrTUlFnT8ZnKkq.KKhgZFj2l3UH0DXMFFAwqM1ggAkZVw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH] mmc_spi: use EILSEQ for possible transmission errors
Date: Wed, 20 May 2009 19:02:51 -0700
User-Agent: KMail/1.9.10
Cc: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>,
       "Matt Fleming" <matt@console-pimps.org>,
       "Pierre Ossman" <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200905192149.07778.david-b@pacbell.net> <200905200220.46569.david-b@pacbell.net> <20090520120851.49783a8e@mjolnir.ossman.eu>
In-Reply-To: <20090520120851.49783a8e@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200905201902.51377.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 May 2009, Pierre Ossman wrote:
> >		 Remember that the
> > firmware in the card can leverage "that's erased" knowledge for
> > things like wear leveling.  SSDs and other storage devices would
> > likewise benefit from such knowledge.  I'm quite certain there's
> > been discussion about adding support for that in the block layer.
> 
> It's already in AFAIK. I even had code for hooking it up to mmc_block.
> But it didn't produce any measurable results so I never merged it.

I'd expect the results would take time to show.  As in, they would
facilitate wear leveling logic, which may be difficult to measure
except by testing various cards to destruction ... even for vendors
that *do* have decent wear leveling.  :)


