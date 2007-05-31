Return-Path: <linux-kernel-owner+w=401wt.eu-S1759052AbXEaXdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052AbXEaXdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 19:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbXEaXdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 19:33:39 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:52900 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbXEaXdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 19:33:38 -0400
Date: Fri, 1 Jun 2007 00:33:27 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Dmitry Torokhov <dtor@insightbb.com>, Richard Hughes <hughsient@gmail.com>,
       linux-acpi@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Message-ID: <20070531233326.GA1947@srcf.ucam.org>
References: <11802004861625-git-send-email-hmh@hmh.eng.br> <d120d5000705301325yf76d062vefbc79873d23e602@mail.gmail.com> <20070531005305.GC6883@khazad-dum.debian.net> <200705310033.51230.dtor@insightbb.com> <20070531222814.GB4076@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531222814.GB4076@khazad-dum.debian.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Input: document the proper usage of EV_KEY and KEY_UNKNOWN
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 07:28:14PM -0300, Henrique de Moraes Holschuh wrote:
> We have all the pieces needed to have sane, generic userland keyboard handling
> in place for a while now, but it was not sufficiently documented (or used!).
> 
> If EV_KEY input drivers always generate scan codes that can be used to
> reprogram their keycode maps, and always generate EV_MSC MSC_SCAN events when
> they output an EV_KEY KEY_UNKNOWN event, userspace can trap those and feed it
> to a generic helper that can ask the user to assign a key code and function to
> that key.

I still disagree that this is the best approach. Userspace already has 
the functionality to map keys if they produce a keycode. Producing 
KEY_UNKNOWN would require the implementation of a stack of extra code.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
