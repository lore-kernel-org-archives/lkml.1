Return-Path: <linux-kernel-owner+w=401wt.eu-S935633AbXJQQ2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935633AbXJQQ2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 12:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760545AbXJQQ2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 12:28:45 -0400
Received: from cavan.codon.org.uk ([78.32.9.130]:40909 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760026AbXJQQ2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 12:28:44 -0400
Date: Wed, 17 Oct 2007 17:28:28 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       davej@redhat.com
Message-ID: <20071017162827.GA9778@srcf.ucam.org>
References: <20071016141153.GA3237@khazad-dum.debian.net> <20071016142121.GA21431@srcf.ucam.org> <20071016143124.GB3237@khazad-dum.debian.net> <20071016144016.GA21749@srcf.ucam.org> <20071016165623.GA13643@khazad-dum.debian.net> <20071016184606.GB25181@srcf.ucam.org> <alpine.LFD.0.999.0710161208340.6887@woody.linux-foundation.org> <d120d5000710161312r5676cad8o60e0790a4e8d5256@mail.gmail.com> <alpine.LFD.0.999.0710161325570.6887@woody.linux-foundation.org> <d120d5000710170857i3f534544pe9cab0ca6c1b0aa4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000710170857i3f534544pe9cab0ca6c1b0aa4@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 11:57:18AM -0400, Dmitry Torokhov wrote:
> say that they only care about notifications arising from keypresses
> then I will add EV_NOTIFY type of events to input layer. What events
> would we need? I can imagine:

Why use EV_NOTIFY? They're still keys. I'd also quibble with the need 
for adding _NOTIFY varients of already existing keys - the existing 
consumers can all cope already.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
