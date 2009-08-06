Return-Path: <linux-kernel-owner+w=401wt.eu-S1754937AbZHFKU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbZHFKU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 06:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbZHFKU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 06:20:28 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:38322 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbZHFKU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 06:20:27 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: fanotify - overall design before I start sending patches
Date: Thu, 6 Aug 2009 11:20:25 +0100
User-Agent: KMail/1.9.10
Cc: Eric Paris <eparis@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "malware-list@dmesg.printk.net" <malware-list@dmesg.printk.net>,
       "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       "greg@kroah.com" <greg@kroah.com>, "jcm@redhat.com" <jcm@redhat.com>,
       Douglas Leeder <douglas.leeder@sophos.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "david@lang.hm" <david@lang.hm>,
       "jengelh@medozas.de" <jengelh@medozas.de>,
       "aviro@redhat.com" <aviro@redhat.com>,
       "mrkafk@gmail.com" <mrkafk@gmail.com>,
       "alexl@redhat.com" <alexl@redhat.com>, "jack@suse.cz" <jack@suse.cz>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "hch@infradead.org" <hch@infradead.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "mmorley@hcl.in" <mmorley@hcl.in>
References: <1248466429.3567.82.camel@localhost> <200908051746.17903.tvrtko.ursulin@sophos.com> <20090806101059.GD31370@elf.ucw.cz>
In-Reply-To: <20090806101059.GD31370@elf.ucw.cz>
MIME-Version: 1.0
Message-Id: <200908061120.26866.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 06/08/2009 11:20:27,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 06/08/2009 11:20:27,
	Serialize complete at 06/08/2009 11:20:27
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 August 2009 11:10:59 Pavel Machek wrote:
> On Wed 2009-08-05 17:46:16, Tvrtko Ursulin wrote:
> > Just to make sure you haven't missed this - it is not that they have to
> > complete the whole operation before the timeout period (since you mention
> > realtime/mlock I suspect this is what you think?), but _during_ the
> > operation they have to show that they are active by sending something
> > like keep alive messages.
> >
> > Or you are worried about failing to meet even that on a loaded system?
> > There has to be something like this otherwise hung userspace client would
> > kill the whole system.
>
> Of course, I'm worried about failing to meet this on loaded
> system. And the fact that I _have_ to worry about that means that
> interface is ugly/broken.

Would you prefer an infinite timeout instead? Maybe Eric could make it 
configurable. Or you have some other alternative ideas?

Tvrtko
