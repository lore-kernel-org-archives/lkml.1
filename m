Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144Ab0CKPuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 10:50:18 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:48585 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933124Ab0CKPuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 10:50:17 -0500
Date: Thu, 11 Mar 2010 16:50:15 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Race condition in TTY ldisc layer in 2.6.33
Message-ID: <20100311155015.GA25607@rere.qmqm.pl>
References: <20100311133222.GA19884@rere.qmqm.pl> <20100311135009.GA8801@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100311135009.GA8801@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 05:50:09AM -0800, Greg KH wrote:
> On Thu, Mar 11, 2010 at 02:32:22PM +0100, Micha? Miros?aw wrote:
> > Looks like there's some race contition in switching ldiscs on USB serial
> > ports. The following warnings trigger sometimes after killing and restarting
> > process that changes ldisc and waits forever. In case you want to look at
> > the code, there it is: http://rere.qmqm.pl/~mirq/sermmc/
> If you apply git commit 638b9648ab51c9c549ff5735d3de519ef6199df3 to the
> 2.6.33 kernel, does it solve the issue for you?

I'm running with the patch now. After couple cycles of starting and killing
the ldisc-setting process I get no warnings. I'll get back to you when/if
I encounter them again.

Best Regards,
Micha³ Miros³aw
