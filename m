Return-Path: <linux-kernel-owner+w=401wt.eu-S1759466AbZADUTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466AbZADUTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 15:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbZADUTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 15:19:21 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:43579
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbZADUTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 15:19:18 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Martin =?utf-8?q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>
Subject: Re: document ext3 requirements
Date: Sun, 4 Jan 2009 13:56:32 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Pavel Machek <pavel@suse.cz>, Duane Griffin <duaneg@dghda.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <20090103123813.GA1512@ucw.cz> <20090103222957.GG1666@elf.ucw.cz> <495FEE66.9080903@ribosome.natur.cuni.cz>
In-Reply-To: <495FEE66.9080903@ribosome.natur.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200901041356.32701.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009 17:01:58 Martin MOKREJŠ wrote:
> > Still handy for recovering badly broken filesystems, I'd say.
>
> Me as well. How about improving you doc patch with some summary of
> this thread (although it is probably not over yet)? ;-) Definitely,
> a note that one can mount it as ext2 while read-only would be helpful
> when doing some forensics on the disk.

Although make sure you _do_ mount it as read only because if you mount an ext3 
filesystem read/write as ext2 I've had it zap the journal entirely and then 
you have to tune2fs -j the sucker to turn it back into ext3.

Ext3 is... touchy.

Rob
