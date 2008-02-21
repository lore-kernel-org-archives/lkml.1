Return-Path: <linux-kernel-owner+w=401wt.eu-S935358AbYBUXnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935358AbYBUXnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758033AbYBUXnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:43:04 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48625 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752781AbYBUXnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:43:01 -0500
Date: Fri, 22 Feb 2008 00:42:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Brownell <david-b@pacbell.net>
Cc: jgarzik@pobox.com, linux-pm@lists.osdl.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [linux-pm] power_state: get rid of write-only variable in SATA
Message-ID: <20080221234220.GC25977@elf.ucw.cz>
References: <20080221125652.GA23548@elf.ucw.cz> <47BDA22F.5060300@pobox.com> <20080221193350.DA772235007@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080221193350.DA772235007@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-02-21 11:33:50, David Brownell wrote:
> > libata uses it under the assumption that "other parts" of the system are 
> > aware of this variable.

There are no other relevant parts, except one debug printk that is
getting removed.

> > May I assume that the API has changed such that this is no longer necessary?
> 
> Yes.  The original motivation for dev->power.power_state was to let

ACK.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
