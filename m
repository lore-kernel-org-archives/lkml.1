Return-Path: <linux-kernel-owner+w=401wt.eu-S1758667AbYAJWxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbYAJWxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbYAJWxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:53:06 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54013 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbYAJWxF (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:53:05 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>, ak@muc.de,
       ebiederm@xmission.com, rdreier@cisco.com, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, mingo@elte.hu, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@infradead.org,
       "Barnes, Jesse" <jesse.barnes@intel.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity map and kernel text
In-Reply-To: Your message of "Thu, 10 Jan 2008 14:15:25 PST."
             <alpine.LFD.1.00.0801101413490.3148@woody.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20080110184840.927409000@intel.com> <20080110184854.787474000@intel.com> <alpine.LFD.1.00.0801101303570.3148@woody.linux-foundation.org> <924EFEDD5F540B4284297C4DC59F3DEE5A2958@orsmsx423.amr.corp.intel.com>
            <alpine.LFD.1.00.0801101413490.3148@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1200005441_2824P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 10 Jan 2008 17:50:41 -0500
Message-ID: <11912.1200005441@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1200005441_2824P
Content-Type: text/plain; charset=us-ascii

On Thu, 10 Jan 2008 14:15:25 PST, Linus Torvalds said:

> Well, I think that /dev/mem should simply give them the right info. That's 
> what people use /dev/mem for - doing things like reading BIOS images etc. 
> 
> So returning *either* a zero page *or* stopping at the first hole is both 
> equally wrong. 

A case could be made that the /dev/mem driver should at *least* prohibit access
to those memory ranges that the kernel already knows have (or might have)
memory-mapped control registers with Bad Juju side-effects attached to them.

Of course, a case could also be made that it should be permitted, because
anybody who tries to read such memory addresses either (a) knows what they're
doing or (b) is about to become an example of evolution in action... ;)

(Personally, I keep a copy of Arjan's "restrict devmem" patch from Fedora
around, so I guess that says which camp I belong in, and the fact it's a Fedora
patch and not mainstream says something too...)


--==_Exmh_1200005441_2824P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHhqFBcC3lWbTT17ARAo7iAJ477vaLijWqQCycYpUEYKjEQVwOlwCePEw7
ePBn+L6JYmJjj014YYYF5Hw=
=VlWe
-----END PGP SIGNATURE-----

--==_Exmh_1200005441_2824P--
