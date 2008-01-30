Return-Path: <linux-kernel-owner+w=401wt.eu-S1758001AbYA3WwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbYA3WwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 17:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbYA3Wvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 17:51:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34517 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbYA3Wvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 17:51:49 -0500
Date: Wed, 30 Jan 2008 22:50:50 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       davem@davemloft.net, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: Value of __*{init,exit} anotations?
Message-ID: <20080130225050.GA10013@flint.arm.linux.org.uk>
Mail-Followup-To: James Bottomley <James.Bottomley@HansenPartnership.com>,
	Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
	davem@davemloft.net, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	"Maciej W. Rozycki" <macro@linux-mips.org>
References: <20080130200336.GN29368@does.not.exist> <1201726817.3292.84.camel@localhost.localdomain> <20080130212011.GA26621@uranus.ravnborg.org> <1201729295.3292.94.camel@localhost.localdomain> <20080130223219.GT29368@does.not.exist> <1201733052.3292.102.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201733052.3292.102.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 04:44:12PM -0600, James Bottomley wrote:
> On Thu, 2008-01-31 at 00:32 +0200, Adrian Bunk wrote:
> > People at linux-arch (Cc'ed) might be better at explaining how often 
> > CONFIG_HOTPLUG gets used in real-life systems and how big the savings 
> > are there.
> > 
> > That might be a good basis for deciding whether it's worth it.
> 
> I'll certainly buy this.  Perhaps killing everything other than __init
> and __exit (meaning discardable whether the system is hotplug, suspend
> or whatever) might get rid of 90% of the problem while still preserving
> 90% of the benefits.  I think a lot of the issues do come from confusion
> over whether it should be __init, __devinint etc .

Just looking at HOTPLUG on ARM by a simple grep, 57 default configurations
for various machines are hotplug enabled out of 75 - so it's roughly 75%.
Whether that 25% remainder cares or not, I'm not sure.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
