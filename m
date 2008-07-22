Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYGVL0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYGVL0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 07:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbYGVLZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 07:25:51 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:48563 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753107AbYGVLZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 07:25:50 -0400
X-Sasl-enc: wzoJWGAyP4a/ItUDNUBWsdX8BXnewGAkINp5/35QYEVQ 1216725949
Date: Tue, 22 Jul 2008 08:25:46 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Philip Langdale <philipl@overt.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       toshiba_acpi@memebeam.org, randy.dunlap@oracle.com
Subject: Re: [PATCH] toshiba_acpi: Add support for bluetooth toggling
	through rfkill
Message-ID: <20080722112546.GD15136@khazad-dum.debian.net>
References: <488256C1.6040802@overt.org> <20080720135239.GA14801@khazad-dum.debian.net> <48855FFB.40808@overt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48855FFB.40808@overt.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008, Philip Langdale wrote:
> Henrique de Moraes Holschuh wrote:
>> Please consider updating your patch to the new style rfkill class.  A quick
>> look at your patch shows that it would benefit from the new
>> RFKILL_STATE_HARD_BLOCKED, and maybe to some rework to separate the
>> bluetooth rfkill controller and the input device switch better.  Depending
>> on the existence of ACPI GPE events when the switch changes state on
>> Toshibas, you may even be able to get rid of some of the polling...
>
> Well, if I can find said GPE, I'll certainly use it. A cursory glance through
> the dis-assembled AML didn't reveal anything obvious. Is there a way to log
> every single acpi event? I though acpid would receive them but it doesn't
> appear to.

Yes, one of the ACPI debug options plus a magic echo to procfs/sysfs. I
don't remember which :-(  But it is there, you will just need to search for
it, unless someone else replies with the exact one.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
