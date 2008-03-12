Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676AbYCLNRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbYCLNRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 09:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbYCLNRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 09:17:42 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:36849 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868AbYCLNRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 09:17:41 -0400
X-Sasl-enc: TkOCwbvYY6qcIyoJBBcOKkiEu178HyoAP1uKCkSMwAxO 1205327860
Date: Wed, 12 Mar 2008 10:17:37 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Alexey Starikovskiy <aystarik@gmail.com>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2 Regression Thinkpad acpi
Message-ID: <20080312131737.GA21290@khazad-dum.debian.net>
References: <20080225204951.GB4432@ics.muni.cz> <20080225210113.GF16513@khazad-dum.debian.net> <20080225220720.GA4523@ics.muni.cz> <20080225230035.GA14503@khazad-dum.debian.net> <20080226184937.GA4280@ics.muni.cz> <20080304194513.GY6704@kernel.dk> <47CDBA74.5080304@gmail.com> <20080304211212.GD6704@kernel.dk> <47CDBE11.4010900@gmail.com> <20080312125912.GM17940@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312125912.GM17940@kernel.dk>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Jens Axboe wrote:
> > >>Please take a look at patches in #10100.
> > >
> > >Can you be more specific (eg if you want me to test any/all of them, let
> > >me know)?
> > >  
> > Patch from comment #3 is in -mm at the moment, and has good chance to 
> > appear in linus tree.
> > I am trying to invent something less crufty along the lines of comment 
> > #4, but not succeeded yet.
> 
> Updating and doing what the bugzilla entry suggests, that is reverting
> the offending commit. That makes my brightness controls work, but the
> volume and mute keys still do not work.

Those are not an ACPI business in your thinkpad anymore.  They go over the
KDC, so we're out of the loop.   That means the bug is fixed completely.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
