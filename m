Return-Path: <linux-kernel-owner+w=401wt.eu-S1757241AbYHONRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbYHONRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 09:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbYHONQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 09:16:55 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:50417 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753041AbYHONQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 09:16:54 -0400
Date: Fri, 15 Aug 2008 09:16:21 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Rik van Riel <riel@redhat.com>,
       Pavel Machek <pavel@suse.cz>, davecb@sun.com,
       Adrian Bunk <bunk@kernel.org>, Mihai Don??u <mdontu@bitdefender.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to
	alinuxinterfaceforonaccess scanning
Message-ID: <20080815131621.GK13048@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Press, Jonathan" <Jonathan.Press@ca.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Rik van Riel <riel@redhat.com>,
	Pavel Machek <pavel@suse.cz>, davecb@sun.com,
	Adrian Bunk <bunk@kernel.org>,
	Mihai Don??u <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
	malware-list@lists.printk.net,
	linux-security-module@vger.kernel.org,
	Arjan van de Ven <arjan@infradead.org>
References: <20080813125638.GB6995@ucw.cz> <20080813135207.CC08C3765BC@pmx1.sophos.com> <20080814125410.GA2262@elf.ucw.cz> <2629CC4E1D22A64593B02C43E855530304AE4BE3@USILMS12.ca.com> <20080814223918.GC6370@elf.ucw.cz> <20080814200005.6b363716@bree.surriel.com> <20080815004335.GF13048@mit.edu> <20080815093513.5ca24c26@lxorguk.ukuu.org.uk> <20080815113528.GI13048@mit.edu> <2629CC4E1D22A64593B02C43E855530304AE4BF5@USILMS12.ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4BF5@USILMS12.ca.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 08:57:48AM -0400, Press, Jonathan wrote:
> That may just be a question of terminology.  If the bits are construed
> not as clean/dirty/infected, but as "I care about this file" vs. "I
> don't care about this file" then the rubber gloves come off.

Sure, as long as we're very clear about the semantics of the bits.  If
the bits are not persistent, but which get dropped if the inode is
every evicted from memory, and it's considered OK, or even desirable,
to rescan the file when it is brought back into memory, that may be
acceptable to the rubber gloves folks (make people go through lots
superflous of security scans, even when they are transfering betewen
flights --- security is always more important than passengers'
convenience!), but perhaps not to other applications such as file
indexers, who would view rescanning files that have already been
scanned, and not have been modified, as a waste of time, battery, CPU
and disk bandwidth, etc.

As I understand it, the TALPA proposal had non-persistent
clean/dirty/infected bits.

						- Ted
