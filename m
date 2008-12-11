Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbYLKAjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbYLKAjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 19:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbYLKAiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 19:38:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756307AbYLKAim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 19:38:42 -0500
Date: Wed, 10 Dec 2008 16:38:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: Tree for December 10
Message-Id: <20081210163817.535cde9a.akpm@linux-foundation.org>
In-Reply-To: <200812110053.49012.rjw@sisk.pl>
References: <20081210164659.9ebb8158.sfr@canb.auug.org.au>
	<20081210145226.8a174e68.akpm@linux-foundation.org>
	<200812110053.49012.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008 00:53:48 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Wednesday, 10 of December 2008, Andrew Morton wrote:
> > On Wed, 10 Dec 2008 16:46:59 +1100
> > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > 
> > > I have created today's linux-next tree at
> > > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> > > (patches at
> > > http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/)
> > 
> > This tree breaks poweroff on my x86_64 test box.  `halt -pfn' does all
> > the usual things, but the machine doesn't turn off.
> > 
> > config: http://userweb.kernel.org/~akpm/config-akpm2.txt
> > dmesg: http://userweb.kernel.org/~akpm/dmesg-akpm2.txt
> > 
> > Any suggestions which don't include the word "bisect" would be most welcome.
> 
> Did you suspend-resume the box before that?

Nope.  I've never tried suspend/resume on that machine, actually.
