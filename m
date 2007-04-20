Return-Path: <linux-kernel-owner+w=401wt.eu-S1767176AbXDTSb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767176AbXDTSb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 14:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767182AbXDTSb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 14:31:58 -0400
Received: from canuck.infradead.org ([209.217.80.40]:52573 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767180AbXDTSb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 14:31:56 -0400
Date: Fri, 20 Apr 2007 11:29:52 -0700
From: Greg KH <greg@kroah.com>
To: Dave Jones <davej@redhat.com>, "Preston A. Elder" <prez@goth.net>,
       linux-kernel@vger.kernel.org
Subject: Re: AGPGart / AMD K7
Message-ID: <20070420182952.GA18930@kroah.com>
References: <46286775.5000507@goth.net> <20070420155537.GA20118@redhat.com> <4628F00B.3010304@goth.net> <20070420173337.GD20118@redhat.com> <462900BD.8020204@goth.net> <20070420182029.GF20118@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420182029.GF20118@redhat.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 02:20:29PM -0400, Dave Jones wrote:
> 
> btw Greg, wtf does driver_register return a 0 as 'success' if it
> completes the function, and 0 as 'failure' if !bus ?
> That seems doomed to failure.

I don't know why the code does that, we should always have a bus
assigned to a driver.  I'll change that and watch to see what breaks :)

thanks,

greg k-h
