Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbYJXN7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbYJXN7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 09:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYJXN7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 09:59:14 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36011 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751375AbYJXN7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 09:59:13 -0400
Date: Fri, 24 Oct 2008 09:59:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: greg@kroah.com, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.27.3 usbcore] Move __module_param_call(nousb) to
 immediately after declaration of nousb.
In-Reply-To: <200810240158.m9O1w2PX032608@www262.sakura.ne.jp>
Message-ID: <Pine.LNX.4.44L0.0810240957580.13114-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2008, Tetsuo Handa wrote:

> Hello.
> 
> I don't know the reason, but the below patch solves the problem which I'm
> experiencing with CONFIG_USB=y on Debian Sarge (gcc (GCC) 3.3.5 (Debian 1:3.3.5-13)).
> 
> Something is wrong with sorting symbol table or walking sysfs tree?

It would be better if you could find the real cause of the problem.  If 
there's something wrong with the kernel code, then it can be fixed.  If 
it's a compiler bug then we can warn people about it.

Alan Stern

