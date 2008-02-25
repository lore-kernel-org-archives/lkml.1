Return-Path: <linux-kernel-owner+w=401wt.eu-S1761991AbYBZASZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761991AbYBZASZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 19:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758653AbYBZASA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 19:18:00 -0500
Received: from ns1.suse.de ([195.135.220.2]:40984 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761791AbYBZAR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 19:17:58 -0500
Date: Mon, 25 Feb 2008 15:56:55 -0800
From: Greg KH <gregkh@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 06/38] quota: turn quotas off when remounting read-only
Message-ID: <20080225235655.GA29077@suse.de>
References: <20080223001946.979768610@mini.kroah.org> <20080223002951.GG7268@suse.de> <20080225215749.GC25449@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225215749.GC25449@duck.suse.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 10:57:49PM +0100, Jan Kara wrote:
> On Fri 22-02-08 16:29:51, Greg KH wrote:
> > 2.6.24-stable review patch.  If anyone has any objections, please let us
> > know.
>   Hmm, this patch is certainly safe from a kernel POV but changes a
> behavior WRT userspace. Previously, user could do:
>   quotaon /
>   mount -o remount,ro /
>   <be lucky>
>   mount -o remount,rw /
>   <have quotas still turned on>
> 
>   But with the patch, the quotas will be turned off. So I'm not sure
> whether it's acceptable as a -stable thing...

Ok, I'll drop it.

thanks,

greg k-h
