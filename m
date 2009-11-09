Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbZKIWJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbZKIWJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 17:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbZKIWJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 17:09:43 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:33870 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbZKIWJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 17:09:42 -0500
Date: Mon, 9 Nov 2009 23:09:44 +0100
From: Daniel Mack <daniel@caiaq.de>
To: David Newall <davidn@davidnewall.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Clemens Ladisch <clemens@ladisch.de>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: make the default cursor shape configurable
Message-ID: <20091109220944.GH14091@buzzloop.caiaq.de>
References: <4AF7D439.4030305@ladisch.de>
 <20091109091044.GX29442@buzzloop.caiaq.de>
 <4AF7DDC1.4090006@ladisch.de>
 <20091109095316.6283fbd6@lxorguk.ukuu.org.uk>
 <4AF7FC64.6030904@ladisch.de>
 <20091109114600.4d91b90e@lxorguk.ukuu.org.uk>
 <20091109145056.GB14091@buzzloop.caiaq.de>
 <4AF8582B.2000403@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF8582B.2000403@davidnewall.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 04:28:03AM +1030, David Newall wrote:
> Daniel Mack wrote:
> > And even if the cursor behaviour is changable at runtime, I don't see
> > why it shouldn't have a selectable compile time default. Which is what
> > the patch adds.
> 
> 
> It seems like adding cruft to the kernel that is just as effectively
> available at run-time. Where does it end? Do we eventually add bash to
> the kernel?

One more thing:

Clemens' last patch didn't add anything to the kernel's binary size.
It didn't slow down anything either, as there is no run-time condition
evaluation. It just makes something configurable which was hard
coded before. So where's the cruft?

The comparison to 'bash in the kernel' is really inappropriate.

Daniel

