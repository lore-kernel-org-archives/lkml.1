Return-Path: <linux-kernel-owner+w=401wt.eu-S1759966AbZEMM6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbZEMM6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 08:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbZEMM6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 08:58:38 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:43615 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbZEMM6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 08:58:38 -0400
MIME-Version: 1.0
In-Reply-To: <1242217342.9974.10.camel@localhost.localdomain>
References: <20090509143742.GA27663@kroah.com> <20090511175626.GA4758@kroah.com> 
	<1242074517.6624.183.camel@moss-terrapins.epoch.ncsc.mil> 
	<ac3eb2510905111405y5541117euf84dd38d39012bd0@mail.gmail.com> 
	<1242132344.31807.48.camel@localhost.localdomain> <ac3eb2510905120810n101dff08yfa945a2ab4b17168@mail.gmail.com> 
	<1242142528.31807.80.camel@localhost.localdomain> <ac3eb2510905120854y7b44f608odf25af159fd6495c@mail.gmail.com> 
	<1242168913.6711.9.camel@poy> <1242217342.9974.10.camel@localhost.localdomain>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 13 May 2009 14:58:18 +0200
Message-ID: <ac3eb2510905130558s493d8c9m667348d183c97721@mail.gmail.com>
Subject: Re: [patch 00/13] devtmpfs patches
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: "David P. Quigley" <dpquigl@tycho.nsa.gov>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jan Blunck <jblunck@suse.de>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 14:22, Stephen Smalley <sds@tycho.nsa.gov> wrote:

> I think you'll actually need to switch credentials around the entire
> sequence starting from vfs_path_lookup() and going through the
> vfs_mknod() call in order to avoid any denials from vfs_path_lookup,
> vfs_mkdir (via create_path), and vfs_mknod.
>
> Then the same issue applies to devtmpfs_delete_node() to prevent unlink
> denials against the current process when a node is removed, similarly
> wrapping everything from the vfs_path_lookup() through the final
> delete_path() call.

Ok, good, will do that. Anything like this to keep in mind when
creating/removing simple subdirectories?

Thanks,
Kay
