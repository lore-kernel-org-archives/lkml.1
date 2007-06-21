Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbXFUPRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbXFUPRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 11:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbXFUPQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 11:16:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756160AbXFUPQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 11:16:57 -0400
Message-ID: <467A9666.2010405@redhat.com>
Date: Thu, 21 Jun 2007 11:16:54 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: oops with USB serial irda adapter
References: <4679A74F.4010901@redhat.com> <20070621001750.283f48ac@the-village.bc.nu>
In-Reply-To: <20070621001750.283f48ac@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2007 07:17 PM, Alan Cox wrote:
> On Wed, 20 Jun 2007 18:16:47 -0400
> Chuck Ebbert <cebbert@redhat.com> wrote:
> 
>> [https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=241598]
>>
>> Oops happens here in kernel 2.6.20.11:
>> drivers/usb/serial/ir-usb.c, line 557:
>>
>>                 /* Notify the tty driver that the termios have changed. */
>>                 port->tty->ldisc.set_termios(port->tty, NULL);
>>
>> (ldisc.set_termios is NULL)
> 
> Yeah the driver is full of bugs - its also broken for the way its
> set_termios tries to play 'guess it the properties have changed' and gets
> speed checks wrong, how it snoops the baud bits and some other stuff it
> does.
> 
> If you make it look like a real serial driver it ought to work fine. If
> you've got hardware I can send you test patches ?

I think I can get the bug reporter to test, so go ahead and send patches.
