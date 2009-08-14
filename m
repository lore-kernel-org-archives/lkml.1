Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235AbZHNByh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbZHNByh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 21:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbZHNByg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 21:54:36 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:50347 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135AbZHNByf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 21:54:35 -0400
X-Sasl-enc: A98r5G55Bo/0mD+S3NsPJiMOPjR+ycl5TmcjH0wX88q2 1250214876
Date: Thu, 13 Aug 2009 22:54:34 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Greg KH <greg@kroah.com>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, len.brown@intel.com,
       stable@kernel.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
       ranma+kernel@tdiedrich.de
Subject: Re: [stable] patch
	thinkpad-acpi-fix-incorrect-use-of-tpacpi_brght_mode_ecnvram.patch
	added to 2.6.30-stable tree
Message-ID: <20090814015434.GA4555@khazad-dum.debian.net>
References: <20090805205011.57FB548DF1@coco.kroah.org> <200908070108.15095.s.L-H@gmx.de> <20090806233111.GB14381@khazad-dum.debian.net> <20090813222801.GA9102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090813222801.GA9102@kroah.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009, Greg KH wrote:
> On Thu, Aug 06, 2009 at 08:31:11PM -0300, Henrique de Moraes Holschuh wrote:
> > On Fri, 07 Aug 2009, Stefan Lippers-Hollmann wrote:
> > > This patch fails to compile if applied to 2.6.30 + current stable queue.
> > [...]
> > > It seems to depend on the new quirk handling, introduced in:
> > > commit 7d95a3d564901e88ed42810f054e579874151999
> > 
> > Good catch.  And I _will_ need that quirk handling stuff to keep 2.6.30 in
> > shape :-(
> 
> Oops, sorry for missing this.
> 
> > The dependencies for the "thinkpad-acpi: fix incorrect use of
> > TPACPI_BRGHT_MODE_ECNVRAM" patch are:
> 
> Due to the need to add a new feature just to get these quirks to work,
> I'll just drop this single patch, which should keep everything building
> properly, right?

Right.  I will hack something and submit it to the next stable.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
