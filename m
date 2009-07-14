Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbZGNKaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbZGNKaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 06:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbZGNKaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 06:30:16 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54202 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754424AbZGNKaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 06:30:15 -0400
X-Sasl-enc: RA1dpyawMKA0mhc3777vdBUrjbFlyUd9bgJD2FwYHeOd 1247567410
Date: Tue, 14 Jul 2009 07:30:07 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       rpurdie@rpsys.net, lenb@kernel.org, rui.zhang@intel.com,
       corentincj@iksaif.net
Subject: Re: [PATCH 1/3] backlight: Allow drivers to update the core, and
 generate events on changes
Message-ID: <20090714103006.GA19866@khazad-dum.debian.net>
References: <1247517685-7719-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247517685-7719-1-git-send-email-mjg@redhat.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009, Matthew Garrett wrote:
> Certain hardware will send us events when the backlight brightness
> changes. Add a function to update the value in the core, and
> additionally send a uevent so that userspace can pop up appropriate
> UI. The uevents are flagged depending on whether the update originated
> in the kernel or from userspace, making it easier to only display UI
> at the appropriate time.

Any reasons to not do it using poll() support (since sysfs has it)?  Or at
least, do both poll and uevents?

Other than that, I like the idea a lot.  thinkpad-acpi will use this event
support.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
