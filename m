Return-Path: <linux-kernel-owner+w=401wt.eu-S1031396AbXFHTea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031396AbXFHTea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbXFHTeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:34:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34087 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751528AbXFHTeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:34:20 -0400
Date: Fri, 8 Jun 2007 12:33:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Fulghum <paulkf@microgate.com>
Cc: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Nicolas Mailhot <nicolas.mailhot@laposte.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [Bug 8473] New: Oops: 0010 [1] SMP
Message-Id: <20070608123350.5cc53c10.akpm@linux-foundation.org>
In-Reply-To: <1181330448.5365.7.camel@amdx2.microgate.com>
References: <200705132102.l4DL2onF003014@fire-2.osdl.org>
	<20070513154718.bb338ceb.akpm@linux-foundation.org>
	<1179098742.7322.5.camel@rousalka.dyndns.org>
	<1179396003.31796.4.camel@rousalka.dyndns.org>
	<20070517094557.c96f7e54.randy.dunlap@oracle.com>
	<1179421196.5000.5.camel@rousalka.dyndns.org>
	<1180206615.3430.8.camel@rousalka.dyndns.org>
	<20070608030629.GA18493@atjola.homenet>
	<1181315809.4811.5.camel@x2.microgate.com>
	<1181330448.5365.7.camel@amdx2.microgate.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Jun 2007 14:20:48 -0500
Paul Fulghum <paulkf@microgate.com> wrote:

> On Fri, 2007-06-08 at 10:16 -0500, Paul Fulghum wrote:
> > On Fri, 2007-06-08 at 05:06 +0200, Bj__rn Steinbrink wrote:
> > > This is do_tty_hangup() exchanging the fops while we're waiting for the
> > > lock. The new fops (hung_up_tty_fops) only have the unlocked variant and
> > > thus we Oops our way.
> ...
> > Here is a patch that restores the locked ioctl for hung_up_tty_ioctl.
> > Can you try it and see if it removes your oops?
> 
> Unfortunately I can't get the timing right to trigger this,
> but it is very clear the locked ioctl fop must not be
> allowed to disappear like my original patch allows.
> 
> Andrew:
> 
> Would you prefer I resend the entire compat ioctl patch or
> submit an incremental patch like in my message I'm quoting above?
> 

The compat_ioctl patch is in mainline, and has been for some time.

Hence a patch against mainline would be appropriate, thanks.
