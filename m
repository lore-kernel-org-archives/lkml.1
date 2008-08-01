Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbYHAKoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbYHAKoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 06:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbYHAKoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 06:44:00 -0400
Received: from trinity.fluff.org ([89.145.97.151]:34954 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbYHAKn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 06:43:59 -0400
Date: Fri, 1 Aug 2008 11:43:47 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: avorontsov@ru.mvista.com, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: Re: libata badness
Message-ID: <20080801104347.GM26938@trinity.fluff.org>
References: <95646AC3-5385-4F59-8EBA-20F811168A87@kernel.crashing.org> <20080731210410.GA623@polina.dev.rtsoft.ru> <DAE7C7B4-CE5B-45EB-B3B4-E5491A843CD9@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DAE7C7B4-CE5B-45EB-B3B4-E5491A843CD9@kernel.crashing.org>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 04:58:05PM -0500, Kumar Gala wrote:
> I figured out the issue.  Its related to the interrupt routing being  
> conveyed to the code from the device tree.  We have a missing 'space'  
> causing issues.

out of interest, is the M5229 attached to a single IRQ in this device
or has the bridge been configured to route the IRQs from the IDE to
the same pin on the PIC?

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.
