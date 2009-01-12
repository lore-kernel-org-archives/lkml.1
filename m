Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbZALKFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbZALKFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbZALKFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:05:07 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59967 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752432AbZALKFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:05:05 -0500
X-Sasl-enc: xEjuysCV9i62O4ygIrFMg65UDLlGb2xtJIDH+q6bkgEd 1231754704
Date: Mon, 12 Jan 2009 08:05:01 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net
Subject: Re: introduce delayed-leds.h to reduce code duplication
Message-ID: <20090112100500.GA31656@khazad-dum.debian.net>
References: <20090111224331.GA28010@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111224331.GA28010@elf.ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jan 2009, Pavel Machek wrote:
> What about something like this? 
> 
> [Alternatively, I can add a flag to the leds class, and make delayed
> leds a built-in functionality...]
> 
> [Attached is driver that uses new infrastructure for hp_accel, but it
> does a bit more.]

FWIW, I am looking over the thinkpad-acpi side of this.  I like the idea,
but I am not completely sure I agree fully with the changes to
thinkpad-acpi.

Which isn't a problem, as long as the thinkpad-acpi hunks are NOT merged to
any tree before my ACK, please.  I will test and comment on the patch before
the weekend.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
