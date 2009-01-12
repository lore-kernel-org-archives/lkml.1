Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbZALTP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbZALTP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 14:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbZALTPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 14:15:20 -0500
Received: from cantor.suse.de ([195.135.220.2]:48645 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbZALTPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 14:15:19 -0500
Date: Mon, 12 Jan 2009 11:13:30 -0800
From: Greg KH <gregkh@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, sfrench@samba.org
Subject: Re: linux-next: Tree for January 12 (cifs vs. staging)
Message-ID: <20090112191330.GC7111@suse.de>
References: <20090112154539.4857f533.sfr@canb.auug.org.au> <496B899E.7060605@oracle.com> <524f69650901121058g73c8022eif1d1bcca5c0e01fa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524f69650901121058g73c8022eif1d1bcca5c0e01fa@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 12:58:42PM -0600, Steve French wrote:
> There is not just the cifs md5 one (which has been around a long
> time), but an md5_init (static) in crypto and the new one in rt.  The
> addition of the new one (rt md5_init) causes the build problem.   It
> would be nice if we could use the same md5 routines though ... last
> time we checked the crypto one was not well suited for calculating
> signatures as a network fs would do though.

I'll fix up the staging rt drivers to not do this, but cifs shouldn't be
declaring such functions as globals either :)

thanks,

greg k-h
