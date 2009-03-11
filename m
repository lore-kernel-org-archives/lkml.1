Return-Path: <linux-kernel-owner+w=401wt.eu-S1752493AbZCKEwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbZCKEwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 00:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbZCKEvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 00:51:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:41569 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbZCKEvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 00:51:39 -0400
Date: Tue, 10 Mar 2009 21:44:20 -0700
From: Greg KH <gregkh@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: panic with strcmp
Message-ID: <20090311044420.GD25840@suse.de>
References: <86802c440903091251x41899167r96680c62c35ad63b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440903091251x41899167r96680c62c35ad63b@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 12:51:53PM -0700, Yinghai Lu wrote:
> happen on kexec loop test, it seems it only do kexec three time continuous.
> only on one two sockets with quad core opteron + 16 sas disks.

Kay just posted a tty kobject patch that should make this go away as it
moves the creation of the core tty objects to later in the boot
sequence, instead of having to create and destroy them all the time.

Could you try that to see if it solves this issue?

thanks,

greg k-h
