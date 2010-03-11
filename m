Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab0CKOAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:00:15 -0500
Received: from kroah.org ([198.145.64.141]:41313 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757918Ab0CKOAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:00:13 -0500
Date: Thu, 11 Mar 2010 05:50:09 -0800
From: Greg KH <greg@kroah.com>
To: Micha? Miros?aw <mirq-linux@rere.qmqm.pl>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Race condition in TTY ldisc layer in 2.6.33
Message-ID: <20100311135009.GA8801@kroah.com>
References: <20100311133222.GA19884@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100311133222.GA19884@rere.qmqm.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 02:32:22PM +0100, Micha? Miros?aw wrote:
> Looks like there's some race contition in switching ldiscs on USB serial
> ports. The following warnings trigger sometimes after killing and restarting
> process that changes ldisc and waits forever. In case you want to look at
> the code, there it is: http://rere.qmqm.pl/~mirq/sermmc/

If you apply git commit 638b9648ab51c9c549ff5735d3de519ef6199df3 to the
2.6.33 kernel, does it solve the issue for you?

thanks,

greg k-h
