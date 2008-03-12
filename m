Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYCLNfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYCLNfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 09:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbYCLNfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 09:35:33 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:47268 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875AbYCLNfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 09:35:32 -0400
X-Sasl-enc: FYSFcr9lUPSsyijRuY+DNctP4UWjHLVcfqHDjGZCYknd 1205328931
Date: Wed, 12 Mar 2008 10:35:29 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Alexey Starikovskiy <aystarik@gmail.com>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2 Regression Thinkpad acpi
Message-ID: <20080312133529.GB21290@khazad-dum.debian.net>
References: <20080225220720.GA4523@ics.muni.cz> <20080225230035.GA14503@khazad-dum.debian.net> <20080226184937.GA4280@ics.muni.cz> <20080304194513.GY6704@kernel.dk> <47CDBA74.5080304@gmail.com> <20080304211212.GD6704@kernel.dk> <47CDBE11.4010900@gmail.com> <20080312125912.GM17940@kernel.dk> <20080312131737.GA21290@khazad-dum.debian.net> <20080312132419.GN17940@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312132419.GN17940@kernel.dk>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Jens Axboe wrote:
> > Those are not an ACPI business in your thinkpad anymore.  They go over the
> > KDC, so we're out of the loop.   That means the bug is fixed completely.
> 
> KDC? Pressing the buttons used to indicate mute and volume level in
> kmix, now they don't. That is somewhat annoying. If there's a way to get
> that working, please let me know.

You shouldn't need to do anything other than teach userspace to respond to
them, as they generate the proper KEY_* events.  If you are giving the AML
_OSI(Linux), at least...

But maybe looking at the keyboard output in console mode, to make triple
sure the events ARE being sent over the KDC as they should, would be in
order?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
