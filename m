Return-Path: <linux-kernel-owner+w=401wt.eu-S932143AbYHTREh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbYHTREh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 13:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761037AbYHTREG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 13:04:06 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4188 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760983AbYHTREE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 13:04:04 -0400
Date: Wed, 20 Aug 2008 19:03:45 +0200
From: Pavel Machek <pavel@suse.cz>
To: Rik van Riel <riel@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Eric Paris <eparis@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Jan Harkes <jaharkes@cs.cmu.edu>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       hch@infradead.org, andi@firstfloor.org, viro@ZenIV.linux.org.uk
Subject: Re: HSM (was Re: [malware-list] TALPA - a threat model?  well sorta.)
Message-ID: <20080820170344.GA7968@ucw.cz>
References: <20080813173529.7069b5f1@cuia.bos.redhat.com> <20080815201622.GD31584@cs.cmu.edu> <20080815150509.20ffb91d@infradead.org> <1219015177.27389.1.camel@localhost.localdomain> <20080818163313.72927af7@lxorguk.ukuu.org.uk> <20080818124339.4b65b6c0@riellaptop.surriel.com> <20080819071416.GA14731@elf.ucw.cz> <20080819121032.02632c09@riellaptop.surriel.com> <20080819192027.GA6484@ucw.cz> <20080819163345.196961f9@riellaptop.surriel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819163345.196961f9@riellaptop.surriel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-08-19 16:33:45, Rik van Riel wrote:
> On Tue, 19 Aug 2008 21:20:27 +0200
> Pavel Machek <pavel@suse.cz> wrote:
> 
> > > If you think FUSE+unionfs is a cleaner solution than one
> > > hook in the VFS, I've got a bridge to sell you.
> > 
> > If you can do it with one clean enough hook, I'll buy that bridge.
> > 
> > [If you want to do 'list directory before files are there' -- and you
> > seem to want to from description above -- fuse seems like a way to
> > go.]
> 
> For a poor man's HSM, it may be a possibility to simply restore
> all the files as sparse files, fetching the content on demand.

Agreed but... I'd rather have rich man's HSM and rich man's antivirus.
You know, I'm going to get very rich, owning that bridge ;-).

[Seriously, FUSE seems to be better way of implementing HSM, and
single hook at open is not enough to implement non-racy antivirus...]

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
