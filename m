Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbXKCJoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbXKCJoX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 05:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbXKCJoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 05:44:16 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:18260 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbXKCJoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 05:44:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UxC41cjod19umlopMT8Hxys3Jq827Jssq0P3+J9CxL3E0oPMnb/HdjV0isx+GBy9RHi6x0ahisLKqsFbOvu4WhLIMPksOaor98792LROwClhNbVYzNpRdGwokFvYwtURIKfuv3IAj4WlI4cYwbaF6ZpysNYHxdJ/wLzrr5iiMo4=
Message-ID: <5699f8f00711030244j4d8bed83j3a9e4a2191201a3c@mail.gmail.com>
Date: Sat, 3 Nov 2007 10:44:14 +0100
From: "Wander Winkelhorst" <w.winkelhorst@gmail.com>
To: "Rik van Riel" <riel@surriel.com>
Subject: Re: WANTED: kernel projects for CS students
Cc: Valdis.Kletnieks@vt.edu, "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       "Pavel Machek" <pavel@ucw.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <20071102233615.6dc90e35@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071014190128.6e3cdb44@bree.surriel.com>
	 <20071028180707.GA6111@ucw.cz>
	 <20071029194820.GC27646@csclub.uwaterloo.ca>
	 <20071029201911.GB3537@elf.ucw.cz>
	 <20071029214452.GA27643@csclub.uwaterloo.ca>
	 <12100.1194059303@turing-police.cc.vt.edu>
	 <20071102233615.6dc90e35@bree.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/3/07, Rik van Riel <riel@surriel.com> wrote:
> On Fri, 02 Nov 2007 23:08:23 -0400
> Valdis.Kletnieks@vt.edu wrote:
>
> > IBM's AIX supported file system compression on the JFS filesystem
> > years ago. I was able to get up to 30% throughput increases by
> > converting the /usr filesystem to compressed - because even a 33mhz
> > Power chipset could read in 5 512-byte blocks and decompress it to
> > the original 4K faster than the disk could read in 8 512-byte
> > blocks.
>
> > Given that today there's an even *bigger* disparity in CPU speed
> > versus disk speed, I'd be surprised if it doesn't help today too.
>
> The problem is that disk seek times have not gotten much
> faster over the years, while disk throughput rates have
> skyrocketed.
>
> Transferring a little less data is not going to help you
> when 80% of your disk time is spent seeking, not reading
> or writing.

This sounds like flash based media are an ideal candidate for compression.
No seek times to speak of, transfer rates that are lower than those of
disks and limited capacity.

I believe JFFS2 (a flash filesystem) allready does compression though.
