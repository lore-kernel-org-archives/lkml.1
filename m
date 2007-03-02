Return-Path: <linux-kernel-owner+w=401wt.eu-S1945902AbXCBMLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945902AbXCBMLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 07:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945903AbXCBMLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 07:11:45 -0500
Received: from cavan.codon.org.uk ([217.147.92.49]:53388 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945902AbXCBMLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 07:11:44 -0500
Date: Fri, 2 Mar 2007 12:11:28 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Werner LEMBERG <wl@gnu.org>, linux-kernel@vger.kernel.org
Message-ID: <20070302121127.GC1212@srcf.ucam.org>
References: <20070302.102351.146595518.wl@gnu.org> <45E7F13E.60408@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E7F13E.60408@drzeus.cx>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: Memory stick reader Ricoh R5C592 supported?
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 10:41:18AM +0100, Pierre Ossman wrote:

> Memory stick is completely unsupported. We haven't got any specs for neither the
> the host controllers or the protocol. So I would guess it would be quite some
> time before memorystick is supported directly by Linux.

There are MS drivers for some Winbond hardware at 
http://zeniv.linux.org.uk/~winbond/ - the combination of those and the 
publically available docs from the memory stick site seems like enough 
to get a protocol driver. The tifm driver also appears to be growing 
memory stick support, and it looks like it's been implemented in a 
fairly generalisable way.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
