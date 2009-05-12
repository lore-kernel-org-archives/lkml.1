Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbZEMALn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbZEMALn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758483AbZEMAJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:09:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758461AbZEMAJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:09:46 -0400
Date: Tue, 12 May 2009 16:50:28 -0700
From: Greg KH <gregkh@suse.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       Stephen Smalley <sds@tycho.nsa.gov>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Jan Blunck <jblunck@suse.de>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: [patch 00/13] devtmpfs patches
Message-ID: <20090512235028.GA3086@suse.de>
References: <20090511175626.GA4758@kroah.com> <1242074517.6624.183.camel@moss-terrapins.epoch.ncsc.mil> <ac3eb2510905111405y5541117euf84dd38d39012bd0@mail.gmail.com> <1242132344.31807.48.camel@localhost.localdomain> <ac3eb2510905120810n101dff08yfa945a2ab4b17168@mail.gmail.com> <1242142528.31807.80.camel@localhost.localdomain> <ac3eb2510905120854y7b44f608odf25af159fd6495c@mail.gmail.com> <1242168913.6711.9.camel@poy> <1242170520.2864.0.camel@moss-terrapins.epoch.ncsc.mil> <ac3eb2510905121634s53c80735h7e6474b214b530d0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510905121634s53c80735h7e6474b214b530d0@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 01:34:13AM +0200, Kay Sievers wrote:
> On Wed, May 13, 2009 at 01:22, David P. Quigley <dpquigl@tycho.nsa.gov> wrote:
> > Does this apply to a vanilla tree or is this on top of your original
> > patch set?
> 
> It updates the one in Greg's tree, which is on top of current Linus'
> git. It does no longer auto-mount devtmpfs in the initramfs, only for
> kernel-mounts, if told to do. So the original issue might no longer be
> visible, unless it is mounted there, or the one line call, that did
> the auto-mount is restored.
> 
> Here is the patch in Greg's tree:
>   http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=blob;f=driver-core/driver-core-devtmpfs-driver-core-maintained-dev-tmpfs.patch;hb=HEAD

I'll replace this version, with your new one, so people can test with
linux-next easier tomorrow.

thanks,

greg k-h
