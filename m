Return-Path: <linux-kernel-owner+w=401wt.eu-S1752222AbZGTPXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbZGTPXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 11:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbZGTPXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 11:23:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:43037 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbZGTPW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 11:22:58 -0400
Date: Mon, 20 Jul 2009 08:10:08 -0700
From: Greg KH <gregkh@suse.de>
To: Krzysztof Oledzki <olel@ans.pl>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.27
Message-ID: <20090720151008.GC10015@suse.de>
References: <20090720040655.GA11940@kroah.com>
 <4A645A45.9060509@ans.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A645A45.9060509@ans.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 01:51:33PM +0200, Krzysztof Oledzki wrote:
> On 2009-07-20 06:06, Greg KH wrote:
> >I'm announcing the release of the 2.6.27.26 kernel.  All users of the
> >2.6.27 kernel series are very strongly encouraged to upgrade.
> >
> >I'll also be replying to this message with a copy of the patch between
> >2.6.27.26 and 2.6.27.27
> >
> >The updated 2.6.27.y git tree can be found at:
> >        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
> >and can be browsed at the normal kernel.org git web browser:
> >        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary
> >
> >thanks,
> 
> <CUT>
> >Linus Torvalds (1):
> >      Don't use '-fwrapv' compiler option: it's buggy in gcc-4.1.x
> 
> I'm very sorry to say that but 2.6.27.27 compiled with gcc-4.2.4
> hangs during boot and it is caused by this fix.
> 
> I extended http://bugzilla.kernel.org/show_bug.cgi?id=13012 with
> additional info & .config.

Wierd.  Linus, any thoughts?  Do we need to check the version of the
compiler that we are using before turning that option off?

thanks,

greg k-h
