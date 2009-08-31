Return-Path: <linux-kernel-owner+w=401wt.eu-S1752889AbZHaM4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbZHaM4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 08:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZHaM4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 08:56:16 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58974 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbZHaM4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 08:56:15 -0400
Date: Mon, 31 Aug 2009 13:56:09 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mark Lord <lkml@rtr.ca>
Cc: Mike Mohr <akihana@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: expresscard hotplug not working
Message-ID: <20090831125609.GA11121@srcf.ucam.org>
References: <4746469c0908251817u225609bax66ea27261a1ef038@mail.gmail.com> <4A96819D.7060708@rtr.ca> <20090830225542.GB901@srcf.ucam.org> <4A9BC239.9060009@rtr.ca> <4A9BC5FB.20000@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9BC5FB.20000@rtr.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 08:45:47AM -0400, Mark Lord wrote:

> With acpiphp loaded, hotplug works on the ExpressCard slot
> of my Dell i9400 notebook.  Well, it *mostly* works.

Ok, that's good.

> The part that is still b0rked is that inserted cards get
> "forgotten" about over suspend/resume (RAM) cycles.

I can entirely believe that that's broken. Thanks, I'll take a look at 
that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
