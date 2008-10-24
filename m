Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbYJXQTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbYJXQTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 12:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbYJXQTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 12:19:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35624 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752927AbYJXQTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 12:19:31 -0400
Date: Fri, 24 Oct 2008 12:19:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: greg@kroah.com, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.27.3 usbcore] Move __module_param_call(nousb)
 toimmediately after declaration of nousb.
In-Reply-To: <200810250026.EGB05240.HJtQFOMSOVOFFL@I-love.SAKURA.ne.jp>
Message-ID: <Pine.LNX.4.44L0.0810241217500.2180-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2008, Tetsuo Handa wrote:

> Hello.
> 
> I succeeded to produce this problem with 2.6.26 .
> Thus, at least, it is not a new bug introduced in 2.6.27 .
> 
> Greg KH wrote:
> > This really sounds like a compiler bug somewhere, reordering this
> > shouldn't "fix" this issue.
> 
> I think so too.

> Well, I'm getting more and more confused.
> It may be gcc3's bug, it may not be gcc's bug.

Why don't you simply look at the output from the compiler?  Either the 
.o file or else the intermediate .s file.

Alan Stern

