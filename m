Return-Path: <linux-kernel-owner+w=401wt.eu-S1753689AbYGaIaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbYGaIaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 04:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYGaI3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 04:29:52 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:46496 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbYGaI3u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 04:29:50 -0400
Date: 31 Jul 2008 10:29:45 +0200
From: krzysztof.h1@poczta.fm
Subject: Re: [Linux-fbdev-devel] [PATCH] atyfb_base.c: fix warning
To: "M. Asselstine" <asselsm@mcmaster.ca>,
       Alexander Beregalov <a.beregalov@gmail.com>
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
       "syrjala@sci.fi" <syrjala@sci.fi>,
       "linux-fbdev-devel@lists.sourceforge.net" 
	<linux-fbdev-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "adaplas@gmail.com" <adaplas@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-ORIGINATE-IP: 83.17.101.58
X-Mailer: PSE
Message-Id: <20080731082945.6AEA31E3074@f03.poczta.interia.pl>
X-EMID: 7a840acc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Jul 30, 2008 at 5:03 PM, Alexander Beregalov
> <a.beregalov@gmail.com> wrote:
> > From: Alexander Beregalov <a.beregalov@gmail.com>
> >
> > atyfb_base.c: fix warning
> >
> > drivers/video/aty/atyfb_base.c:2663: warning: 'aty_resume_chip' defined
> > but not used
> >
> > Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> > Cc: Ville Syrjala <syrjala@sci.fi>
> > Cc: Antonino A. Daplas <adaplas@pol.net>
> 
> Looks good, should you maybe move the aty_resume_chip() up into the
> existing #if defined(CONFIG_PM) &&... that atyfb_pci_resume() is in?
> Not sure, just a thought.
> 

The same thought has crossed my mind. Kill the forward declaration and move this short function before atyfb_pci_resume().

Regards,
Krzysztof 


----------------------------------------------------------------------
W kosciele tez zdarzaja sie wpadki!
Smieszny filmik >>> http://link.interia.pl/f1e61

