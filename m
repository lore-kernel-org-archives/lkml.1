Return-Path: <linux-kernel-owner+w=401wt.eu-S1756674AbZALTdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbZALTdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 14:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbZALTdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 14:33:41 -0500
Received: from ns1.suse.de ([195.135.220.2]:50087 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbZALTdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 14:33:40 -0500
Date: Mon, 12 Jan 2009 11:32:18 -0800
From: Greg KH <gregkh@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, sfrench@samba.org
Subject: Re: linux-next: Tree for January 12 (cifs vs. staging)
Message-ID: <20090112193218.GA7751@suse.de>
References: <20090112154539.4857f533.sfr@canb.auug.org.au> <496B899E.7060605@oracle.com> <524f69650901121058g73c8022eif1d1bcca5c0e01fa@mail.gmail.com> <20090112191330.GC7111@suse.de> <524f69650901121123i1765dc3fye3ce636c91dd25bd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524f69650901121123i1765dc3fye3ce636c91dd25bd@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

On Mon, Jan 12, 2009 at 01:23:07PM -0600, Steve French wrote:
> Is there some magic compile option alternative (other than renaming
> the function, which may be ok, since others probably don't depend on
> it)?  MD5Init is used outside fs/cifs/md5.c so can't be static

No, you should rename it to cifs_md5init to show that it is only for the
cifs module to use.  Try not to polute the global namespace with generic
function names.

thanks,

greg k-h
