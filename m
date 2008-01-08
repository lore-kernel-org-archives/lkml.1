Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbYAHV7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbYAHV7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbYAHV6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:58:09 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2810 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752229AbYAHV6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:58:00 -0500
Date: Tue, 8 Jan 2008 21:46:26 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, ebiederm@xmission.com, kzak@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org
Subject: Re: [patch 7/9] unprivileged mounts: allow unprivileged fuse mounts
Message-ID: <20080108214625.GE5050@ucw.cz>
References: <20080108113502.184459371@szeredi.hu> <20080108113630.861045063@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108113630.861045063@szeredi.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-01-08 12:35:09, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Use FS_SAFE for "fuse" fs type, but not for "fuseblk".
> 
> FUSE was designed from the beginning to be safe for unprivileged users.  This
> has also been verified in practice over many years.  In addition unprivileged

Eh? So 'kill -9 no longer works' and 'suspend no longer works' is not
considered important enough to even mention?

'updatedb no longer works' is not a problem?

Are you ready to offer shell account for bugtraq people to see how
long it survives?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
