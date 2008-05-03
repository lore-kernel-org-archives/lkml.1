Return-Path: <linux-kernel-owner+w=401wt.eu-S1762666AbYECJoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762666AbYECJoV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 05:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759231AbYECJoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 05:44:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:20342 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758923AbYECJoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 05:44:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qZeXqtAd5lPaL8xxSmPHlbrWpQPH5HxQ8NHGk2AI4LZrXnrQlkCQbnoU+HaG8t4b1fa3cEEuRTq0Ijl2HIAw7QjycSRSgLcueIH1mTbiV0QBf2Xm7h0Swl48smC8WiV9+fwTFfNqSPOmtSgLhagvP/g+U6Rbwyswn/Sac8Cg58g=
Message-ID: <84144f020805030244y44313fdl17cee6fa38bfd690@mail.gmail.com>
Date: Sat, 3 May 2008 12:44:12 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: LogFS merge
Cc: "Willy Tarreau" <w@1wt.eu>,
       "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@logfs.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Arnd Bergmann" <arnd@arndb.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080503091111.GH5838@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080502133234.GA24080@logfs.org>
	 <alpine.LFD.1.10.0805021010040.5994@woody.linux-foundation.org>
	 <20080502202151.GB24080@logfs.org>
	 <alpine.LFD.1.10.0805021328200.5994@woody.linux-foundation.org>
	 <20080502213146.GD24080@logfs.org>
	 <alpine.LFD.1.10.0805021438180.5994@woody.linux-foundation.org>
	 <20080502215833.GG24080@logfs.org> <20080503070318.GR8474@1wt.eu>
	 <20080503091111.GH5838@cs181133002.pp.htv.fi>
X-Google-Sender-Auth: c572d658bb07e6c0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Sat, May 3, 2008 at 12:11 PM, Adrian Bunk <bunk@kernel.org> wrote:
> > Why not merge it and mark it experimental then ? In fact, this is about
> > what you're looking for : reduced merge hassle and more testers.
>
>  Andi already answered that one:
>
> "Merging file systems too early can quickly ruin their name and that
>   taint is hard to ever get rid again then (e.g. happened to JFS)"
>
>  And a stable kernel shouldn't be something for getting "more testers",
>  it should be for tested code ready to be used in production.
>  What you call "more testers" would be people who try it in production
>  (e.g. to overcome shortcomings of JFFS2) thinking it was stable.
>
>  And no, EXPERIMENTAL in the kernel is not usable for keeping people from
>  trying known-whacky code.

I think ext4 already set the precedent that you _can_ do development
within the 2.6 series, no?
