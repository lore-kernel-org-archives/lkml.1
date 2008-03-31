Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbYCaLjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbYCaLjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 07:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYCaLjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 07:39:37 -0400
Received: from phunq.net ([64.81.85.152]:51900 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751986AbYCaLjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 07:39:36 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Mon, 31 Mar 2008 04:39:14 -0700
User-Agent: KMail/1.9.5
Cc: david@lang.hm, David Newall <davidn@davidnewall.com>,
       Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803180233.10156.phillips@phunq.net> <20080318135725.425f63df@core>
In-Reply-To: <20080318135725.425f63df@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803310439.14978.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 March 2008 06:57, Alan Cox wrote:
> > If the primary server goes down then we lose exactly one interesting
> > data element stored only in its memory: the ramdisk dirty map.  Though
> > we could be much cleverer, the backup server will simply set its entire
> > map to dirty when it takes over, and will duly sync back the entire
> > ramdisk to media a few minutes later.
> 
> Assuming the 1010 has proper power isolation that makes sense and would
> give you pretty much what was wanted. Especially as you can replace the
> secondary server with a small system which does *nothing* but sync the
> ramdisk back and so is far less likely to crash.

The 1010 just has power rails that connect to dual power supplies if
that is what you mean.

> Does make you wonder why its not built into the violin ;)

Perhaps adding what amounts to a server motherboard did not make sense,
when an external server can already do the job.  I don't know, there is
a certain purity in the JBOM concept (just a box of memory), and no
doubt they were able to bring this beast to market earlier because of
it.

I would be far from surprised to see a later incarnation incorporate a
hard disk.  Did I mention it already has Linux running inside it to do
the raid management etc?

Regards,

Daniel
