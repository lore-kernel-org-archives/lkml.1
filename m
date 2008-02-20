Return-Path: <linux-kernel-owner+w=401wt.eu-S1762792AbYBTSJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762792AbYBTSJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761174AbYBTSIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:08:55 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:50131 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760986AbYBTSIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:08:54 -0500
Date: Wed, 20 Feb 2008 19:08:52 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: David Rees <drees76@gmail.com>
cc: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       LKML <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: very poor ext3 write performance on big filesystems?
In-Reply-To: <72dbd3150802200944s16e84e62tf13c19935915bc55@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802201908150.26109@fbirervta.pbzchgretzou.qr>
References: <47B980AC.2080806@wpkg.org> <p7363wmxsxr.fsf@bingen.suse.de> 
 <20080218141640.GC12568@mit.edu> <47B99E0C.8020706@wpkg.org> 
 <20080218151632.GD25098@mit.edu>  <20080218155725.GB26622@one.firstfloor.org>
  <20080218153501.GE25098@mit.edu>  <Pine.LNX.4.64.0802201156520.26109@fbirervta.pbzchgretzou.qr>
 <72dbd3150802200944s16e84e62tf13c19935915bc55@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 20 2008 09:44, David Rees wrote:
>On Wed, Feb 20, 2008 at 2:57 AM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>>  But GNU tar does not handle acls and xattrs. So back to rsync/cp/mv.
>
>Huh? The version of tar on my Fedora 8 desktop (tar-1.17-7) does. Just
>add the --xattrs option (which turns on --acls and --selinux).

Yeah they probably whipped it up with some patches.

$ tar --xattrs
tar: unrecognized option `--xattrs'
Try `tar --help' or `tar --usage' for more information.
$ tar --acl
tar: unrecognized option `--acl'
Try `tar --help' or `tar --usage' for more information.
$ rpm -q tar
tar-1.17-21
(Not everything that runs rpm is a fedorahat, though)
