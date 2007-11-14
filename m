Return-Path: <linux-kernel-owner+w=401wt.eu-S1762540AbXKNFLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762540AbXKNFLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 00:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbXKNFLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 00:11:06 -0500
Received: from [212.12.190.148] ([212.12.190.148]:49848 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750893AbXKNFLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 00:11:04 -0500
From: Al Boldi <a1426z@gawab.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: mm snapshot broken-out-2007-11-13-04-14.tar.gz uploaded
Date: Wed, 14 Nov 2007 08:09:51 +0300
User-Agent: KMail/1.5
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
References: <200711131821.54056.a1426z@gawab.com> <200711131942.10195.a1426z@gawab.com> <5021.1194990201@turing-police.cc.vt.edu>
In-Reply-To: <5021.1194990201@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711140809.51644.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Tue, 13 Nov 2007 19:42:10 +0300, Al Boldi said:
> > Oh.  What about breaking out a stable-mm snapshot against the latest
> > stable kernel?
>
> You can roll your own of those.
>
> Get a 2.6.23.N kernel tarball.
> patch -R the 23.N patch against that, giving you a 23.0 tree.
> Apply patch-2.6.24-rc2 to that.
>
> Now apply the snapshot.

Ok, but I was thinking of allowing a more selective approach.  First, break 
out an mm snapshot that only contain patch-sets that are deemed stable, but 
still not ready for rc.  Then, a tool may allow to selectively apply a 
specific patch-set against the latest stable kernel, not the rc.  This could 
possibly improve longer-term testing, instead of just relying on crunch-time 
rc testing.


Thanks!

--
Al

