Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbZH2UWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbZH2UWL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 16:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbZH2UWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 16:22:10 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:45417
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbZH2UWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 16:22:09 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is possible
Date: Sat, 29 Aug 2009 15:22:06 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; x86_64; ; )
Cc: david@lang.hm, Ric Wheeler <rwheeler@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
References: <20090824212518.GF29763@elf.ucw.cz> <alpine.DEB.2.00.0908280748080.6822@asgard.lang.hm> <20090829100558.GH1634@ucw.cz>
In-Reply-To: <20090829100558.GH1634@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908291522.07694.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 August 2009 05:05:58 Pavel Machek wrote:
> On Fri 2009-08-28 07:49:38, david@lang.hm wrote:
> > On Thu, 27 Aug 2009, Rob Landley wrote:
> >> Pavel's response was to attempt to document this.  Not that journaling
> >> is _bad_, but that it doesn't protect against this class of problem.
> >
> > I don't think anyone is disagreeing with the statement that journaling
> > doesn't protect against this class of problems, but Pavel's statements
> > didn't say that. he stated that ext3 is more dangerous than ext2.
>
> Well, if you use 'common' fsck policy, ext3 _is_ more dangerous.

The filesystem itself isn't more dangerous, but it may provide a false sense of 
security when used on storage devices it wasn't designed for.

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
