Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbYEDRmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbYEDRmo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 13:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbYEDRmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 13:42:35 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:32815 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782AbYEDRme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 13:42:34 -0400
X-Sasl-enc: j+CFs3seeeYhelTTHabO1D71sahtiyZXVIjqfS/dD/oi 1209922953
Date: Sun, 4 May 2008 14:42:29 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jean Delvare <khali@linux-fr.org>, Kasper Sandberg <lkml@metanurb.dk>,
       Rudolf Marek <r.marek@assembler.cz>,
       Maxim Levitsky <maximlevitsky@gmail.com>, trenn@suse.de,
       Len Brown <lenb@kernel.org>, Matthew <jackdachef@gmail.com>,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: Linux 2.6.25 (coretemp reads high temperatures)
Message-ID: <20080504174229.GA29118@khazad-dum.debian.net>
References: <200804182151.49021.lenb@kernel.org> <200804231143.10875.maximlevitsky@gmail.com> <1209406784.11608.15.camel@localhost> <1209474423.1784.837.camel@queen.suse.de> <20080429170824.09540206@hyperion.delvare> <48179DB4.8040701@assembler.cz> <1209514274.27499.12.camel@localhost> <20080430082005.4b76186f@hyperion.delvare> <20080430145110.GC3543@khazad-dum.debian.net> <20080502203615.GF3956@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080502203615.GF3956@ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 May 2008, Pavel Machek wrote:
> > Actually, just libsensors would, and the local admin can adjust it at
> > will using the config file.
> > 
> > Nobody in userspace should be reading hwmon sysfs directly without the
> > use of libsensors.  If they are, it is their bug, and it is unsupported
> > AFAIK.
> 
> Hmm, that's an interesting ABI design. No, I do not think that's a
> good idea.

That's how it is.  The kernel drivers are to attempt to do their best to
give proper readings.  But if they don't, the library can apply
arbritary user-configurable adjustments.

I'd rather different attribute names like "raw_temp#" were used when the
adjustment thorugh libsensors is *required*, though.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
