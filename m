Return-Path: <linux-kernel-owner+w=401wt.eu-S1752665AbXCaWpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbXCaWpQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 18:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbXCaWpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 18:45:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbXCaWpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 18:45:14 -0400
Date: Sat, 31 Mar 2007 15:43:18 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: dtor@insightbb.com, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, stuard_hayes@dell.com, zaitcev@redhat.com
Subject: Re: usb hid: reset NumLock
Message-Id: <20070331154318.05724805.zaitcev@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0703312122100.6040@jikos.suse.cz>
References: <20070330105924.01a16dd6.zaitcev@redhat.com>
	<Pine.LNX.4.64.0703312122100.6040@jikos.suse.cz>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2007 21:35:19 +0200 (CEST), Jiri Kosina <jkosina@suse.cz> wrote:
> On Fri, 30 Mar 2007, Pete Zaitcev wrote:

> I think I see an issue here. Imagine that you boot a system initially with 
> one keyboard connected (usb, ps/2, doesn't matter), and after some time 
> you connect second USB keyboard (the NumLock is 'on' on the first keyboard 
> when you connect the second one).
> 
> Without your patch, the NumLock led will be OK on the second keyboard 
> immediately. With your patch, the NumLock will be forced to 'off' and it 
> will be out of sync with the first keyboard. The leds will get in sync 
> later when any change occurs. 

Oh, right, I missed it. The difficulty is how I rely on usages and fields
being already mapped by hidinput_configure_usage(). Thanks for letting me
know, I'll think about it.

-- Pete
