Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbYCMM7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbYCMM7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 08:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbYCMM7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:59:38 -0400
Received: from brick.kernel.dk ([87.55.233.238]:3274 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbYCMM7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:59:37 -0400
Date: Thu, 13 Mar 2008 13:59:34 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Arkadiusz Miskiewicz <arekm@maven.pl>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2 Regression Thinkpad acpi
Message-ID: <20080313125933.GT17940@kernel.dk>
References: <20080225230035.GA14503@khazad-dum.debian.net> <20080312133529.GB21290@khazad-dum.debian.net> <20080312135521.GE8141@ics.muni.cz> <200803121952.42666.arekm@maven.pl> <20080312193637.GA27873@ics.muni.cz> <20080312211306.GD30864@khazad-dum.debian.net> <20080313120514.GH17940@kernel.dk> <20080313122344.GD27873@ics.muni.cz> <20080313124633.GS17940@kernel.dk> <20080313125503.GE27873@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313125503.GE27873@ics.muni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13 2008, Lukas Hejtmanek wrote:
> On Thu, Mar 13, 2008 at 01:46:33PM +0100, Jens Axboe wrote:
> > They do not generate any events, xev reports nothing. The ThinkVantage
> > button doesn't generate any events either.
> 
> what about BIOS upgrade? I think this really should work.

The BIOS isn't that old, probably updated it a couple of months ago.

> Ahh, maybe you are facing EC problems? Are you using just stock vanila
> kernel or some additional patches?

It's stock -git as of this morning, with the
208c70a45624400fafd7511b96bc426bf01f8f5e commit reverted. And some other
unrelated patches I'm working on, but nothing that has anything remotely
to do with this.

-- 
Jens Axboe

