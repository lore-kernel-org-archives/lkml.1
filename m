Return-Path: <linux-kernel-owner+w=401wt.eu-S1756368AbYH3Ted@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368AbYH3Ted (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 15:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbYH3TeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 15:34:23 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:2365 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbYH3TeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 15:34:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DC5oW1pZFWQ8vv3R/B+WupWBOqFMmmlssUGDuVVJd4TYFBLEI7KK6hzD5kWCSl0VSu
         R22uX9Ld2rV+IwpE1/eavgfxti5fmXop3GHvOaln3bLCP4XG00pyz5gco4jgKGbiwsHs
         ubsyGA6KVevsgqtWKQYXl6HeU4o7cauEQRoCg=
Message-ID: <19f34abd0808301234k3fae5572xdd8835827201f15@mail.gmail.com>
Date: Sat, 30 Aug 2008 21:34:21 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: buffer overflow in /proc/sys/sunrpc/transports
Cc: "Tom Tucker" <tom@opengridcomputing.com>, "Neil Brown" <neilb@suse.de>,
       "Chuck Lever" <chuck.lever@oracle.com>, "Greg Banks" <gnb@sgi.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080830192112.GD7611@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080830184422.GA9598@localhost.localdomain>
	 <20080830190642.GC7611@lenovo>
	 <19f34abd0808301215i445e8411q987c864c0b478d30@mail.gmail.com>
	 <20080830192112.GD7611@lenovo>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 9:21 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> | Hm. I think this is wrong. Shouldn't we copy as many bytes as the user
> | indicated?
>
> Well, hard to say what user-space programmer is expecting from us.
> I mean - maybe he (reader) wants only part of results not the whole
> contents BUT by this way he never know what the whole conetnts would be
> until trying to read more (ie to check if there no more data from
> kernel side). What is preferred behaviour - i don't know :)

For any other file, read(1) + read(1) should be exactly equivalent to
a read(2). What's the difference here?

(Btw, thanks for the quick reply :-))


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
