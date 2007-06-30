Return-Path: <linux-kernel-owner+w=401wt.eu-S1757710AbXF3P4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbXF3P4h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 11:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbXF3P41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 11:56:27 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:45047 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbXF3P40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 11:56:26 -0400
X-Greylist: delayed 1877 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Jun 2007 11:56:26 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=EvUuInMA+4HTbozyZXzBHjF3xYMxGqf6yGpsaWXpo/PiM8yuo2utcGZPH18zZ
	S84haeXfFFekMfBVFwnXXA5SA==
Date: Sat, 30 Jun 2007 17:25:07 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       =?iso-8859-1?B?VPZy9ms=?= Edvin <edwintorok@gmail.com>,
       netdev@vger.kernel.org, power@bughost.org, zambrano@broadcom.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] b44: power down PHY when interface down
Message-ID: <20070630152507.GB2553@xi.wantstofly.org>
References: <4354d3270706300447ladcda4by987b1f87963112f9@mail.gmail.com> <20070630120541.GA21339@srcf.ucam.org> <46866C6B.9010801@linux.intel.com> <20070630151923.GA22983@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070630151923.GA22983@srcf.ucam.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2007 at 04:19:23PM +0100, Matthew Garrett wrote:

> I'd agree that there's a need for a state where we power down as much as 
> possible (even at the cost of functionality), but where possible it 
> would also be nice to offer a state where the mac is powered down and 
> the phy left up.

There are PHYs which can detect that someone's on the other end even
when powered down..
