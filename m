Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbZALUYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbZALUYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbZALUY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:24:27 -0500
Received: from ns.suse.de ([195.135.220.2]:54090 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbZALUY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:24:26 -0500
Date: Mon, 12 Jan 2009 12:21:36 -0800
From: Greg KH <gregkh@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, sfrench@samba.org
Subject: Re: linux-next: Tree for January 12 (cifs vs. staging)
Message-ID: <20090112202136.GA8854@suse.de>
References: <20090112154539.4857f533.sfr@canb.auug.org.au> <496B899E.7060605@oracle.com> <524f69650901121058g73c8022eif1d1bcca5c0e01fa@mail.gmail.com> <20090112191330.GC7111@suse.de> <524f69650901121123i1765dc3fye3ce636c91dd25bd@mail.gmail.com> <20090112193218.GA7751@suse.de> <524f69650901121213l76dd4b6ap831d6da16876422f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524f69650901121213l76dd4b6ap831d6da16876422f@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 02:13:29PM -0600, Steve French wrote:
> On Mon, Jan 12, 2009 at 1:32 PM, Greg KH <gregkh@suse.de> wrote:
> > On Mon, Jan 12, 2009 at 01:23:07PM -0600, Steve French wrote:
> >> Is there some magic compile option alternative (other than renaming
> >> the function, which may be ok, since others probably don't depend on
> >> it)?  MD5Init is used outside fs/cifs/md5.c so can't be static
> >
> > No, you should rename it to cifs_md5init to show that it is only for the
> > cifs module to use.  Try not to polute the global namespace with generic
> > function names.
> 
> Looks like cifs has the following related functions which I can rename
> if that makes it easier:
> 001a2e9 R_386_PC32        MD5Final
> 0001a302 R_386_PC32        MD5Update
> 0001a38c R_386_PC32        MD5Init
> 0001a39f R_386_PC32        MD5Update

That would make life easier for you as well :)

> Any others that I missed ...

Not that I see at the moment, but you might want to look at all of your
global symbol names to make sure they start with "cifs_".

thanks,

greg k-h
