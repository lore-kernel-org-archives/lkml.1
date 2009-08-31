Return-Path: <linux-kernel-owner+w=401wt.eu-S1753262AbZHaNPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbZHaNPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 09:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbZHaNPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 09:15:20 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33011 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbZHaNPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 09:15:20 -0400
Date: Mon, 31 Aug 2009 14:15:14 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mark Lord <lkml@rtr.ca>
Cc: Mike Mohr <akihana@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: expresscard hotplug not working
Message-ID: <20090831131514.GA11752@srcf.ucam.org>
References: <4746469c0908251817u225609bax66ea27261a1ef038@mail.gmail.com> <4A96819D.7060708@rtr.ca> <20090830225542.GB901@srcf.ucam.org> <4A9BC239.9060009@rtr.ca> <4A9BC5FB.20000@rtr.ca> <20090831125609.GA11121@srcf.ucam.org> <4A9BCC0B.1010107@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9BCC0B.1010107@rtr.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 09:11:39AM -0400, Mark Lord wrote:

> Another thing that could be a factor here, is that neither method
> (acpiphp or pciehp) seems "automatic".  The user has to know to load
> one or the other module, or at least manually add them to /etc/modules.

Yes. There's no reasonable way of dealing with this - even if you came 
up with some sort of modaliases, the order in which the drivers are 
probed is significant (some hardware will work with both pciehp and 
acpiphp, but prefers the former). The only real way to handle this is to 
build them both in.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
