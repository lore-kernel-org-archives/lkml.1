Return-Path: <linux-kernel-owner+w=401wt.eu-S1761401AbXJRGqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761401AbXJRGqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 02:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbXJRGqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 02:46:00 -0400
Received: from john.hrz.tu-chemnitz.de ([134.109.132.2]:59147 "EHLO
	john.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbXJRGp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 02:45:59 -0400
X-Greylist: delayed 2448 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Oct 2007 02:45:59 EDT
Date: Thu, 18 Oct 2007 08:05:06 +0200
From: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
To: Jeff Garzik <jeff@garzik.org>, akpm@linux-foundation.org
Cc: Badari Pulavarty <pbadari@us.ibm.com>, netdev@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, satyam@infradead.org
Subject: Re: [PATCH] vortex_up should initialize "err"
Message-ID: <20071018060506.GA30544@newton.mathematik.tu-chemnitz.de>
References: <1192662956.14504.14.camel@dyn9047017100.beaverton.ibm.com> <4716A8B4.5060406@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4716A8B4.5060406@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.3 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: 5ce44a36c4f4b1c7ddfb73cb65031a54
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 08:28:36PM -0400, Jeff Garzik wrote:
> Badari Pulavarty wrote:
> >Simple compile warning fix. (against 2.6.23-git12)
> >
> >Thanks,
> >Badari
> >
> >vortex_up() should initialize 'err' for a successful return.
> >
> >drivers/net/3c59x.c: In function `vortex_up':
> >drivers/net/3c59x.c:1494: warning: `err' might be used uninitialized in 
> >this function
> 
> applied as an obvious bug fix (Steffen added to CC)
> 

Hm, we had already the 3c59x-fix-uninitialized-variable-bug.patch from
Satyam Sharma in -mm to fix this, but the patch was removed from -mm
some time ago. Andrew, what happened to this one?

However, this issue should be fixed.

Thanks,

Steffen
