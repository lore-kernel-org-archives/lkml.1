Return-Path: <linux-kernel-owner+w=401wt.eu-S1759642AbXFAAY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642AbXFAAY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 20:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbXFAAYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 20:24:48 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:60788 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbXFAAYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 20:24:47 -0400
Date: Fri, 1 Jun 2007 01:24:35 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Dmitry Torokhov <dtor@insightbb.com>, Richard Hughes <hughsient@gmail.com>,
       linux-acpi@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Message-ID: <20070601002435.GA2621@srcf.ucam.org>
References: <11802004861625-git-send-email-hmh@hmh.eng.br> <d120d5000705301325yf76d062vefbc79873d23e602@mail.gmail.com> <20070531005305.GC6883@khazad-dum.debian.net> <200705310033.51230.dtor@insightbb.com> <20070531222814.GB4076@khazad-dum.debian.net> <20070531233326.GA1947@srcf.ucam.org> <20070601001304.GB5407@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601001304.GB5407@khazad-dum.debian.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Input: document the proper usage of EV_KEY and KEY_UNKNOWN
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 09:13:04PM -0300, Henrique de Moraes Holschuh wrote:

> Well, we already produce KEY_UNKNOWN anyway, and the stuff you quoted above
> just makes KEY_UNKNOWN useful for something instead of keeping it as an
> useless notice to the user that some key (which one? who knows!) was
> pressed.

Given existing userspace, it's never useful to generate KEY_UNKNOWN. 
Adding extra information to the event doesn't alter that.

> Perhaps what you dislike re. KEY_UNKNOWN is the part where KEY_UNKNOWN+scan
> code is declared to be the prefered way to report keys that do not have a
> specific function?  Your reply seems to indicate this, but I am not sure I
> really understood what you meant.

Yes.

> I am not exactly in love with the idea of using KEY_UNKNOWN in place of
> stuff like KEY_FN_F1 either (I'd prefer to just bump up KEY_MAX and have
> more posicional keycodes), but Dmitry is being quite clear that he does not
> want to increase KEY_MAX to add more positional keycodes.

I think using positional keycodes would also be a mistake. We just need 
a slightly larger set of keycodes representing user-definable keys. 
There's 4 of them already - I really can't imagine there being many 
keyboards with a significantly larger set of unlabelled keys.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
