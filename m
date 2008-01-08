Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbYAHV6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbYAHV6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbYAHV6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:58:04 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2802 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752161AbYAHV57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:57:59 -0500
Date: Tue, 8 Jan 2008 21:47:22 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, ebiederm@xmission.com, kzak@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org
Subject: Re: [patch 1/9] unprivileged mounts: add user mounts to the kernel
Message-ID: <20080108214721.GF5050@ucw.cz>
References: <20080108113502.184459371@szeredi.hu> <20080108113619.213519920@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108113619.213519920@szeredi.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue 2008-01-08 12:35:03, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> This patchset adds support for keeping mount ownership information in the
> kernel, and allow unprivileged mount(2) and umount(2) in certain cases.
> 
> The mount owner has the following privileges:
> 
>   - unmount the owned mount
>   - create a submount under the owned mount

- create traps for updatedb, etc?

Is there Doc* file somewhere describing dangers of allowing this?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
