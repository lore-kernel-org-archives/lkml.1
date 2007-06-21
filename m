Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbXFUQXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbXFUQXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbXFUQXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:23:38 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53386 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbXFUQXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:23:36 -0400
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that
	through other means
From: Ram Pai <linuxram@us.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
In-Reply-To: <46799A31.10301@zytor.com>
References: <467994BD.6000403@zytor.com>
	 <20070620210343.GQ21478@ftp.linux.org.uk>  <46799A31.10301@zytor.com>
Content-Type: text/plain
Date: Thu, 21 Jun 2007 09:20:37 -0700
Message-Id: <1182442837.3342.13.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-20 at 14:20 -0700, H. Peter Anvin wrote:
> Al Viro wrote:
> > On Wed, Jun 20, 2007 at 01:57:33PM -0700, H. Peter Anvin wrote:
> >> ... or, alternatively, add a subfield to the first field (which would
> >> entail escaping whatever separator we choose):
> >>
> >> /dev/md6 /export ext3 rw,data=ordered 0 0
> >> /dev/md6:/users/foo /home/foo ext3 rw,data=ordered 0 0
> >> /dev/md6:/users/bar /home/bar ext3 rw,data=ordered 0 0
> > 
> > Hell, no.  The first field is in principle impossible to parse unless
> > you know the fs type.
> > 
> > How about making a new file with sane format?  From the very
> > beginning.  E.g. mountpoint + ID + relative path + type + options,
> > where ID uniquely identifies superblock (e.g. numeric st_dev)
> > and backing device (if any) is sitting among the options...
> 
> Okay, I see there has been some discussion on this earlier, based on a
> proposal by Ram Pai, so it pretty much comes down to redesigning this
> right.  I see some issues with his proposal (device numbers exported to
> userspace in text form should be separated into major:minor form, for
> one thing.)  I know the util-linux-ng people have also had issues with
> /proc/mounts that they would like resolved in order to finally nuke
> /etc/mtab.
> 
> Is Ram still working on this?  I'd like to help make this happen so we
> can be done with it.

Peter, I am not working on it currently. But i am interested in getting
it done. I have the seed set of patches which had Al Viro's ideas
incorporated. Infact those patches were sent on lkml 2 months back.
Shall we start with those patches?

RP


> 
> 	-hpa
> 
> 

