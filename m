Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbZHSVt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbZHSVt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 17:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbZHSVt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 17:49:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53743 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753075AbZHSVt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 17:49:56 -0400
Date: Wed, 19 Aug 2009 22:50:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Bruno =?ISO-8859-14?B?UHLpbW9udA==?= <bonbons@linux-vserver.org>,
       Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
Message-ID: <20090819225034.470c52e8@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.0908191648160.3229-100000@iolanthe.rowland.org>
References: <20090819221532.6b4e8a4a@neptune.home>
	<Pine.LNX.4.44L0.0908191648160.3229-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So Alan, what's the explanation?  An unsuccessful open method call
> should not lead to a close method call.

For tty it always has since back in 0.9x, and most drivers depend upon
this behaviour.

Alan

