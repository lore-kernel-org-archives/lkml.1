Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbYAOKx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbYAOKx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbYAOKxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:53:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:48892 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbYAOKxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:53:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XqRAHR2MZ5Au1Yj+jr5H8wDpy5s4bL7poP8K4Uo5Dz4QKu5GI+RWFYtTECgIEj7OV4SQ30nm3IDg2J5XVpSPZl7xgdeGYx0zcvWZx3jrfdHQNZ7QfrVEXq3JWq6Cz4c5Jw+FW967sWy5/TJCwZWQJn2ifNR4gIJY5HQOooo/ewc=
Message-ID: <643ea2b10801150253i735d7342q73bf01f864d6167c@mail.gmail.com>
Date: Tue, 15 Jan 2008 08:53:42 -0200
From: "A. C. Censi" <accensi@gmail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [patch 9/9] unprivileged mounts: add "no submounts" flag
Cc: serue@us.ibm.com, akpm@linux-foundation.org, hch@infradead.org,
       viro@ftp.linux.org.uk, ebiederm@xmission.com, kzak@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org
In-Reply-To: <E1JEjEE-0000xZ-RU@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080108113502.184459371@szeredi.hu>
	 <20080108113634.382855604@szeredi.hu>
	 <20080114233910.GI6704@sergelap.austin.ibm.com>
	 <E1JEjEE-0000xZ-RU@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 15, 2008 8:41 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > Quoting Miklos Szeredi (miklos@szeredi.hu):
> > > From: Miklos Szeredi <mszeredi@suse.cz>
> > >
> > > Add a new mount flag "nomnt", which denies submounts for the owner.
> > > This would be useful, if we want to support traditional /etc/fstab
> > > based user mounts.
> > >
> > > In this case mount(8) would still have to be suid-root, to check the
> > > mountpoint against the user/users flag in /etc/fstab, but /etc/mtab
> > > would no longer be mandatory for storing the actual owner of the
> > > mount.
> >
> > Ah, I see, so the floppy drive could be mounted as a MNT_NOMNT but
> > MNT_USER mount with mnt_owner set.  Makes sense.  I'd ask for a better
> > name than 'nomnt', but I can't think of one myself.
>
> Me neither.
>

Why not "nosubmnt"?


-- 
A. C. Censi
accensi [em] gmail [ponto] com
accensi [em] montreal [ponto] com [ponto] br
