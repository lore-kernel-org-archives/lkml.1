Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbYAPJoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbYAPJoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 04:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYAPJo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 04:44:28 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36814 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbYAPJo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 04:44:26 -0500
To: serue@us.ibm.com
CC: miklos@szeredi.hu, accensi@gmail.com, serue@us.ibm.com,
       akpm@linux-foundation.org, hch@infradead.org, viro@ftp.linux.org.uk,
       ebiederm@xmission.com, kzak@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       util-linux-ng@vger.kernel.org
In-reply-to: <20080115134719.GB4453@sergelap.austin.ibm.com>
	(serue@us.ibm.com)
Subject: Re: [patch 9/9] unprivileged mounts: add "no submounts" flag
References: <20080108113502.184459371@szeredi.hu> <20080108113634.382855604@szeredi.hu> <20080114233910.GI6704@sergelap.austin.ibm.com> <E1JEjEE-0000xZ-RU@pomaz-ex.szeredi.hu> <643ea2b10801150253i735d7342q73bf01f864d6167c@mail.gmail.com> <E1JEjUx-00010q-Ny@pomaz-ex.szeredi.hu> <20080115134719.GB4453@sergelap.austin.ibm.com>
Message-Id: <E1JF4ne-0003HO-CG@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 16 Jan 2008 10:43:10 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Why not "nosubmnt"?
> > 
> > Why not indeed.  Maybe I should try to use my brain sometime.
> 
> Well it really should have 'user' or 'unpriv' in the name
> somewhere.  'nosubmnt' is more confusing than 'nomnt' because
> it no submounts really sounds like a reasonable thing in
> itself...

I slept on it, and I still think 'nosubmnt' might be the best
compromise.  Obviously the superuser has privileges, that override
what is normally allowed, and we don't find it strange when a
read-only file is happily being written by root.

It may feel wrong in the context of mounts, because we are so used to
mounts being privileged-only.

Objections?  Once this goes in, it will stay the same forever, so now
is the time to express any doubts...

Thanks,
Miklos
