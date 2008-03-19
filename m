Return-Path: <linux-kernel-owner+w=401wt.eu-S940335AbYCTATs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940335AbYCTATs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933572AbYCSXff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:35:35 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50604 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760972AbYCSXf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:35:28 -0400
To: miklos@szeredi.hu
CC: viro@ZenIV.linux.org.uk, miklos@szeredi.hu, akpm@linux-foundation.org,
       linuxram@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <E1Jbx0r-00027l-0q@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Wed, 19 Mar 2008 13:03:21 +0100)
Subject: Re: [patch 4/6] vfs: mountinfo show dominating group id
References: <20080313212641.989467982@szeredi.hu> <20080313212737.053993902@szeredi.hu> <20080319113704.GJ10722@ZenIV.linux.org.uk> <E1Jbx0r-00027l-0q@pomaz-ex.szeredi.hu>
Message-Id: <E1JbxGg-0002Ec-SD@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 19 Mar 2008 13:19:42 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  Makes reliable parsing of
> > the damn thing in userland impossible.  IOW, fs options should go _last_
> > and they should follow an unconditionally present field.
> 
> But then we lose the ability to later extend the format by adding
> fields at the end.  Which is one of the things that would be nice to
> have, in contrast to /proc/mounts, which we are so afraid to touch now.
> 
> So maybe some alternative, multi line format would be better?
> 
> MountID: 99
> ParentID: 88
> DevID: 0:34
> Type: foofs
> Source: /dev/foo
> Root: /
> MountPoint: /mnt/foo
> MountOpts: rw,noatime
> Opts: rw,errors=continue
> Propagation: shared:42

Which still doesn't fully solve the problem, since ->show_options()
can also spew newlines + MountID:.  Oh well.

Miklos
