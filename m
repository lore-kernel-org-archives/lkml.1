Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbYAXMVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbYAXMVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 07:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbYAXMVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 07:21:36 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:55672 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbYAXMVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 07:21:35 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] Missing usb_find_device symbol from usb.c
Date: Thu, 24 Jan 2008 13:24:26 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Wilco Beekhuizen" <wilcobeekhuizen@gmail.com>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org
References: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com> <200801241249.06577.oliver@neukum.org> <84144f020801240352r688fbbccu52ce9aa8ea3f199@mail.gmail.com>
In-Reply-To: <84144f020801240352r688fbbccu52ce9aa8ea3f199@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801241324.26868.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 24. Januar 2008 12:52:45 schrieb Pekka Enberg:
> Hi Oliver,
> 
> On Jan 24, 2008 1:49 PM, Oliver Neukum <oliver@neukum.org> wrote:
> > A quick glance through the files at sourceforge indicates that this
> > device use a file transfer protocol. Mapping this to a simple device
> > is hard. A fs is quite natural a representation of that.
> 
> Sure but the filesystems in fs/ are general purpose and they can be
> mounted on top of any block device (except for the in-memory ones like

nfs, cifs, jffs, ...

> sysfs). Furthermore, the problem with iriverfs is that it assumes that
> there can be only one device plugged to the host. What we want is
> something like
> 
>   $ mount -t iriverfs /dev/iriver0 /mnt/media
> 
> Which can be accomplished with an USB driver in driver/usb/ that
> registers the special iriverfs.

And what happens if you do
mount -t vfat /dev/iriver0 /mnt/media ?

	Regards
		Oliver
