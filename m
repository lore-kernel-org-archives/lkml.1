Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbXE0NBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbXE0NBf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 09:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbXE0NB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 09:01:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53337 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbXE0NB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 09:01:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Documentation on /sys/power/resume
Date: Sun, 27 May 2007 15:06:45 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel M/L <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
References: <4658C807.9040005@tmr.com> <200705271253.03396.rjw@sisk.pl> <46597F37.5050107@tmr.com>
In-Reply-To: <46597F37.5050107@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705271506.45714.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 27 May 2007 14:53, Bill Davidsen wrote:
> Rafael J. Wysocki wrote:
> > Hi,
> > 
> > On Sunday, 27 May 2007 01:51, Bill Davidsen wrote:
> >> Not in the ABI doc, is there and doc at all, and if not could someone 
> >> who knows where it's used might give me a hint, as a quick look didn't 
> >> bring enlightenment. Or is it a future hook which doesn't work yet?
> > 
> > That's something that in theory may allow you to resume the system from
> > and initrd script.
> > 
> > Basically, you write your resume device's major and minor numbers
> > into it as the "MAJ:MIN" string (eg. "8:3" for /dev/sda3 on my box) and the
> > kernel will try to read the image from this device and restore it.
> > 
> > It only works with partitions and the use of it us discouraged, so it's
> > deliberately undocumented.
> > 
> Thanks, that's just different enough from what little info I had to make 
> what I have not work. I'm looking at resume from a non-swap location.

Only suspend2 can do this right now.  The built-in swsusp can resume from a
swap file as long as it's not located on LVM.

Greetings,
Rafael
