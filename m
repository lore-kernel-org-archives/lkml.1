Return-Path: <linux-kernel-owner+w=401wt.eu-S1757427AbZGGQM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbZGGQM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbZGGQMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:12:15 -0400
Received: from outbound-mail-130.bluehost.com ([67.222.38.30]:34697 "HELO
	outbound-mail-130.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751125AbZGGQMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:12:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=FpMKye1g3d+OcR30rRFpWOHnR3IVOKH8vteEvetglRTO3bjRAJR1JBY8B+lucs9siJSAKp+2Apfi/2vHTW8wUxtHHPyDhIGED0ZTEmWJ3DQqLlALABM++Unz/A4uPnsg;
Date: Tue, 7 Jul 2009 09:11:48 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: David Howells <dhowells@redhat.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, dhowells@redhat.com,
       trivial <trivial@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>, Tony Luck <tony.luck@intel.com>,
       benh@kernel.crashing.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       mchehab@infradead.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg Ungerer <gerg@snapgear.com>, Greg KH <greg@kroah.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Ingo Molnar <mingo@elte.hu>, tytso@mit.edu, sct@redhat.com,
       Gadiyar Anand <gadiyar@ti.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] [PATCH 0/22] trivial fixes typo "foo foo"
Message-ID: <20090707091148.7bdfcdd3@jbarnes-g45>
In-Reply-To: <16756.1246981440@redhat.com>
References: <1246975428.3613.10.camel@ht.satnam>
	<16756.1246981440@redhat.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Jul 2009 16:44:00 +0100
David Howells <dhowells@redhat.com> wrote:

> Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > Jaswinder Singh Rajput (22):
> >       trivial: fix typo "has has" in multiple files
> >       trivial: fix typo "on on" in multiple files
> >       trivial: fix typo "that that" in multiple files
> 
> NAK.  You can't just mechanically reduce the above pairs of words to
> a single instance unconditionally.
> 
> "has has" should perhaps be "has had" in some cases.
> 
> In "on on", the first preposition may be part of a compound verb (eg:
> "to go on").
> 
> In "that that", the second "that" may be specifying the object in
> relation to a previous part of the text.

What's more, these types of patchsets don't actually improve things in
any real way.  If these changes were submitted as part of some greater
work, involving clarifying the text or making the text match the code,
or cleaning up the code in some real way (refactoring common stuff etc)
I'd be fine with it.

But as it stands it just makes lkml that much more difficult to read,
and clogs the changelog with fairly useless bits.  But maybe I'm
missing the "greater work" part of this set; I haven't looked at all 22
patches here.

-- 
Jesse Barnes, Intel Open Source Technology Center
