Return-Path: <linux-kernel-owner+w=401wt.eu-S1759424AbYBRMIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424AbYBRMIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758052AbYBRMIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:08:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbYBRMIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:08:34 -0500
To: Greg KH <greg@kroah.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
From: Andi Kleen <andi@firstfloor.org>
References: <098123kjff90231nv098233rnvd908u234@garzik.org>
	<20080217195235.GN14588@uranus.ravnborg.org>
	<20080218045209.GA15141@kroah.com>
Date: Mon, 18 Feb 2008 13:08:33 +0100
In-Reply-To: <20080218045209.GA15141@kroah.com> (Greg KH's message of "Sun\, 17 Feb 2008 20\:52\:09 -0800")
Message-ID: <p73zltyxy9q.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:
>
> If Jeff does that, I still can't drop those PCI functions from the PCI
> core, which I desperatly want to do as they do not play nice with modern
> systems (meaning hotplug...).
>
> So either way, I think his patches should go in.

Merging essentially untested patches does not seem like a good strategy.
And there is definitely still a large ISDN user base too.

My personal guess is that there are far more ISDN users than (non cardbus)
PCI/PCI-e hotplug users.

-Andi
