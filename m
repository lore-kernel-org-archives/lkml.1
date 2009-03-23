Return-Path: <linux-kernel-owner+w=401wt.eu-S1759206AbZCWP72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206AbZCWP72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbZCWP7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:59:12 -0400
Received: from kroah.org ([198.145.64.141]:60385 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755089AbZCWP7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:59:11 -0400
Date: Mon, 23 Mar 2009 08:32:56 -0700
From: Greg KH <greg@kroah.com>
To: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Cc: Corey Minyard <minyard@acm.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Subject: Re: [PATCH] limit CPU time spent in kipmid (PREVIOUS WAS BROKEN)
Message-ID: <20090323153256.GA7528@kroah.com>
References: <49C27281.4040207@fujitsu-siemens.com> <49C2B994.7040808@acm.org> <20090319235114.GA18182@kroah.com> <49C3B6A5.5030408@acm.org> <20090320174701.GA14823@kroah.com> <49C3E03E.10506@acm.org> <49C78BE0.9090107@fujitsu-siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C78BE0.9090107@fujitsu-siemens.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 02:17:20PM +0100, Martin Wilck wrote:
> +module_param(kipmid_max_busy, uint, 0);

Can you make this modifiable at runtime by setting the mode to 0644?
That way people would not have to unload and then reload the module in
order to be able to fix their machines, as they usually don't know they
have a problem until they run their system for a while.

thanks,

greg k-h
