Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbZIXPBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbZIXPBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 11:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbZIXPBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 11:01:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34856 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753314AbZIXPBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:01:15 -0400
Date: Thu, 24 Sep 2009 16:01:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Alan Cox <alan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-2.6.31 INIT: open(/dev/console): Input/output error (due
 to  commit b50989dc444599c8b21edc23536fc305f4e9b7d5)
Message-ID: <20090924160136.44e31ad0@lxorguk.ukuu.org.uk>
In-Reply-To: <b6a2187b0909240624u2821a312ub6d02df21d552248@mail.gmail.com>
References: <b6a2187b0909240624u2821a312ub6d02df21d552248@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 21:24:45 +0800
Jeff Chua <jeff.chua.linux@gmail.com> wrote:

> Latest linux pull few days ago broke the console.
> 
> The error during boot up while switching from init S to M showed
> 
> INIT: open(/dev/console): Input/output error
> 
> 
> Reverting this commit solves the problem. This is 100% repeatable on a
> "real" machine, but does not show up on kvm or vmware guest console.

It is timing dependant. A discussion and some fixes were posted a while
ago.
