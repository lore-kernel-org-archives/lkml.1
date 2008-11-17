Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbYKQPCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbYKQPCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbYKQPCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:02:04 -0500
Received: from eazy.amigager.de ([213.239.192.238]:48985 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbYKQPCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:02:02 -0500
Date: Mon, 17 Nov 2008 15:26:40 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [ibm-acpi-devel] [PATCH] ACPI: thinkpad-acpi: fix fan
	sleep/resume path
Message-ID: <20081117142639.GA2600@x61>
Mail-Followup-To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org
References: <20081109113011.GB8329@khazad-dum.debian.net> <1226235242-11130-2-git-send-email-hmh@hmh.eng.br> <20081117021408.GD22260@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117021408.GD22260@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 00:14:08 -0200, Henrique de Moraes Holschuh wrote:
> Len,
> 
> The patch needs to go to Linus...  I don't think anyone cares to have
> their names as tested-by:, or they would have replied already.
> 
> I have tested the patch and it fixes things here.  It would be better with
> more "works for me" replies, but it should be enough testing.

Hi,

sorry for the delay. I tested the above patch and the "auto" fan level
was preserved (or better: not touched) at resume, so this regression is
fixed.

Regards,
Tino
