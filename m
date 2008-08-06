Return-Path: <linux-kernel-owner+w=401wt.eu-S1762052AbYHFQO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762052AbYHFQO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 12:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761207AbYHFQNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 12:13:53 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:60280 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761047AbYHFQNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 12:13:50 -0400
In-Reply-To: <20080806114604.5a714d11@cuia.bos.redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       Theodore Tso <tytso@MIT.EDU>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon access
 scanning
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: tvrtko.ursulin@sophos.com
Date: Wed, 6 Aug 2008 17:12:56 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 06/08/2008 17:13:45,
	Serialize by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 06/08/2008 17:13:45,
	Serialize complete at 06/08/2008 17:13:45,
	S/MIME Sign failed at 06/08/2008 17:13:45: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 06/08/2008 17:12:57,
	Serialize complete at 06/08/2008 17:12:57
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080806161350.0660837659D@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote on 06/08/2008 16:46:04:

> On Wed, 6 Aug 2008 11:33:23 -0400
> "Press, Jonathan" <Jonathan.Press@ca.com> wrote:
> 
> > Even so, I don't think your extreme examples are really parallel to 
what
> > we do.  Personally, I think that scanning on open, exec and close is 
not
> > excessive. 
> > 
> > And in fact, we do go out of our way to avoid scanning when it really
> > isn't necessary.  For example, that's the reason that we want a cache 
--
> 
> Disks are slow and files are getting larger by the day.
> 
> We can do a lot better than scanning a whole file.  A mechanism
> that can notify programs about what file changed and what byte
> range in the file changed can reduce scanning overhead by only
> needing to scan the part of the file that changed.

It is much more advanced than that, really. I don't know if ever a whole 
file is read and in 99% it is just a tiny part of it. I don't know what I 
am allowed to disclose and also it is not my area of expertise, but if you 
are interested in how detection actually works maybe we can talk off list 
and put you in touch with some other people here.

It is also wrong to think that you can scan only what has changes because 
that bit may be harmless itself but present a final part of a malware 
puzzle.
 
> More importantly, getting info on which bytes in a file changed
> will also help backup programs and disk indexing programs.

True, but Nick mentioned some huge issues with access after close and 
munmap in one of your previous postings. It sounds to me that would be a 
huge VM/filesystem work to actually enable things like this.
 
> What we need to work on is making sure that the interfaces
> that go into the kernel are useful not just for anti-virus
> programs, but also for other software.

I definitely agree with that.

Tvrtko


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

