Return-Path: <linux-kernel-owner+w=401wt.eu-S1751431AbXBMXD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbXBMXD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 18:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbXBMXD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 18:03:59 -0500
Received: from ns1.suse.de ([195.135.220.2]:52586 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbXBMXD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 18:03:58 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Neil Brown <neilb@suse.de>
Subject: Re: Bug in current -git tree causing dbus and gnome to chew up cpu time
Date: Tue, 13 Feb 2007 15:03:43 -0800
User-Agent: KMail/1.9.5
Cc: Greg KH <greg@kroah.com>, torvalds@linux-foundation.org,
       viro@zeniv.linux.org.uk, hch@lst.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20070213195116.GA5181@kroah.com> <20070213213737.GA14383@kroah.com> <17874.15886.523387.629797@notabene.brown>
In-Reply-To: <17874.15886.523387.629797@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702131503.43545.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 February 2007 14:39, Neil Brown wrote:
> On Tuesday February 13, greg@kroah.com wrote:
> > This causes the following to just loop over and over, incrementing the
> > pid:
> >
> > gnome-vfs-daemo(8914):
>
> That's odd.  getcwd returning an empty string.
> I can only see that happening if you do the equivalent of
>    chdir("/");
>    chroot("/somewhere");
>    getcwd(buf,sizeof(buf));

The other case I'm aware of is this:

  $ mount -o loop image /mnt
  $ cd /mnt
  $ umount -l /mnt
  $ /bin/pwd

Andreas
