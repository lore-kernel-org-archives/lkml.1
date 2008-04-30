Return-Path: <linux-kernel-owner+w=401wt.eu-S1761907AbYD3PDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761907AbYD3PDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 11:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760780AbYD3PC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 11:02:59 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:28457 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760675AbYD3PC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 11:02:57 -0400
Date: Wed, 30 Apr 2008 08:01:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "SL Baur" <steve@xemacs.org>
Cc: "Andres Salomon" <dilinger@queued.net>, "Sam Ravnborg" <sam@ravnborg.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Dave Jones" <davej@codemonkey.org.uk>,
       "Roland McGrath" <roland@redhat.com>
Subject: Re: Additional kconfig targets (cloneconfig, nonint_oldconfig etc)
Message-Id: <20080430080134.60346a12.randy.dunlap@oracle.com>
In-Reply-To: <ed10ee420804300345r5d4566d2uff5c3f49f1c15107@mail.gmail.com>
References: <20080429183531.GB19652@uranus.ravnborg.org>
	<20080429172402.14d7d40b@ephemeral>
	<ed10ee420804300345r5d4566d2uff5c3f49f1c15107@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 03:45:57 -0700 SL Baur wrote:

> On 4/29/08, Andres Salomon <dilinger@queued.net> wrote:
> > On Tue, 29 Apr 2008 20:35:31 +0200
> >  Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> >  > And we add support for a new 'commandline' parameter
> >  > 'K' so I can say:
> >  >
> >  > make K=/proc/config.gz defconfig
> >  > make K=i386_defconfig  defconfig
> >  > make K=i386_defconfig  oldconfig
> >  > make K=/proc/config.gz newconfig
> >  >
> >  > So K is used to specify what config file we use
> >  > to start out from.
> 
> I like this idea a lot.  I didn't like the hardcoded `.config' 13
> years ago and I still
> don't like it now.
> 
> >  Sounds good, I highly prefer specifying the config via env variable
> >  rather than embedded in the target (ie, 'make olpc_defconfig').
> 
> Is there any reasonable way to embed the configuration file name in the kernel
> image like BSD does it?  /proc/config.gz is a good way to retrieve way to
> retrieve configuration information on a running system, not so good for pushing
> kernels out to a network and keeping track of the config files on the build
> machine.

I don't know how BSD does it, but CONFIG_IKCONFIG does embed the
config image in the kernel.  It can be extracted with
scripts/extract-ikconfig.

> I don't have any way of checking this now, but can /proc files like
> /proc/config.gz
> be exported via NFS or the equivalent?

---
~Randy
