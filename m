Return-Path: <linux-kernel-owner+w=401wt.eu-S1761031AbXGTRhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761031AbXGTRhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763649AbXGTRgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:36:12 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:56039 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937189AbXGTRgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:36:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=V0qWidH9dLsMyIzjKShkq6j6ikOVC1vlAVo4NpQumRkKDutA2udoyqYZ7iMTwz0yDiegdmUKhF0FvrndgqkLEjJJcXXJaF2rQqZYUyO/L2nyrLLdVIZFuFKkZlApa9d6;
Message-ID: <46A0F282.8070103@simon.arlott.org.uk>
Date: Fri, 20 Jul 2007 18:36:02 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Denis Cheng <crquan@gmail.com>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] run scripts/Lindent on it to match Documentation/CodingStyle
References: <1184489571313-git-send-email-crquan@gmail.com> <4699EEA9.6070709@simon.arlott.org.uk> <20070720170743.GF14791@parisc-linux.org>
In-Reply-To: <20070720170743.GF14791@parisc-linux.org>
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/07/07 18:07, Matthew Wilcox wrote:
> Of course, we can't add this flag to Lindent until it's widely
> circulating amongst the distributions.  Perhaps we can add this to
> Lindent in the meantime:
> 
> sed -i -e 's/^\t*      \(\w*:\)/ \1/' "$@"
> 
> which will replace the leading tabs and spaces with one space.
> It should leave case labels unmolested, as they should be indented with
> tabs, not 6 spaces.

... isn't the space thing a workaround for a "diff -p" bug?

Labels should either not have any indent or be indented by tabs (since
some code could presumably benefit from indenting labels). Mass
replacing any labels run through Lindent with space prefixes would seem
like a bad idea :/


(From original reply)
It has a habit of leaving/creating "^\t+ +" too, and that "\t\t/*
comment */$" oddity, I couldn't see any options in the man page to fix
those...

-- 
Simon Arlott
