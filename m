Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbYAIJTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbYAIJTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 04:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbYAIJSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 04:18:48 -0500
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:51443 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbYAIJSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 04:18:45 -0500
Date: Wed, 9 Jan 2008 11:19:04 +0200 (MET DST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
X-X-Sender: szaka@dhcppc1
To: Nigel Cunningham <nigel@nigel.suspend2.net>
cc: Miklos Szeredi <miklos@szeredi.hu>, pavel@ucw.cz,
       akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, ebiederm@xmission.com, kzak@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org
Subject: Re: [patch 7/9] unprivileged mounts: allow unprivileged fuse mounts
In-Reply-To: <47840DAC.5000108@nigel.suspend2.net>
Message-ID: <Pine.LNX.4.61.0801091106010.4441@dhcppc1>
References: <20080108113502.184459371@szeredi.hu> <20080108113630.861045063@szeredi.hu>
 <20080108214625.GE5050@ucw.cz> <E1JCN9I-0004DB-DF@pomaz-ex.szeredi.hu>
 <47840DAC.5000108@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wed, 9 Jan 2008, Nigel Cunningham wrote:
> On Tue 2008-01-08 12:35:09, Miklos Szeredi wrote:
> >
> > For the suspend issue, there are also no easy solutions.
> 
> What are the non-easy solutions?

A practical point of view I've seen only fuse rootfs mounts to be a 
problem. I remember Ubuntu patches for this (WUBI and some other distros 
install NTFS root). But this probably also depends on the used suspend 
implementation.

Personally I've never had fuse related suspend problem with ordinary mounts 
during heavy use under development, nor NTFS user problem was tracked down 
to it in the last one and half year.

Regards,
	    Szaka

-- 
NTFS-3G:  http://ntfs-3g.org
