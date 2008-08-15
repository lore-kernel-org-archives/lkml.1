Return-Path: <linux-kernel-owner+w=401wt.eu-S1757002AbYHOLgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbYHOLgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 07:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbYHOLgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 07:36:00 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:49229 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752891AbYHOLf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 07:35:58 -0400
Date: Fri, 15 Aug 2008 07:35:29 -0400
From: Theodore Tso <tytso@mit.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rik van Riel <riel@redhat.com>, Pavel Machek <pavel@suse.cz>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, davecb@sun.com,
       Adrian Bunk <bunk@kernel.org>, Mihai Don??u <mdontu@bitdefender.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
	access scanning
Message-ID: <20080815113528.GI13048@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Rik van Riel <riel@redhat.com>,
	Pavel Machek <pavel@suse.cz>,
	"Press, Jonathan" <Jonathan.Press@ca.com>, davecb@sun.com,
	Adrian Bunk <bunk@kernel.org>,
	Mihai Don??u <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
	malware-list@lists.printk.net,
	linux-security-module@vger.kernel.org,
	Arjan van de Ven <arjan@infradead.org>
References: <20080813125638.GB6995@ucw.cz> <20080813135207.CC08C3765BC@pmx1.sophos.com> <20080814125410.GA2262@elf.ucw.cz> <2629CC4E1D22A64593B02C43E855530304AE4BE3@USILMS12.ca.com> <20080814223918.GC6370@elf.ucw.cz> <20080814200005.6b363716@bree.surriel.com> <20080815004335.GF13048@mit.edu> <20080815093513.5ca24c26@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815093513.5ca24c26@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 09:35:13AM +0100, Alan Cox wrote:
> We shouldn't need to care what people do with good interface. What
> matters is in your airport example is that at the infrastructure level
> there is a point you can choose to do scanning and we agree where.
> Whether people use this to provide a Starbucks or goons with rubber
> gloves who take away babies milk is an application layer problem.

If it's a good interface that also happens to address HSM/DMAPI
functionality, as well as a more efficient way for trackerd to work, I
agree completely.  I think you will agree the proposed TALPA interface
is a bit too virus-scanner specific, though?  Especially with explicit
talk of specialized (persistent or not) "clean/dirty/infected" bits
that the kernel would store in the inode for the benefit of the AV
scanner?  That's rather optimized for the goons-with-rubber-gloves
that-make-mothers-drink-their-own-breast-to-prove-it's-not-explosives
crowd, I think...

       	     	      	  	    		   - Ted
