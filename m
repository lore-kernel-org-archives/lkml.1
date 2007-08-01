Return-Path: <linux-kernel-owner+w=401wt.eu-S1762079AbXHAJEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762079AbXHAJEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbXHAJEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:04:30 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:2295 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186AbXHAJE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:04:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a7GJosvEbHHixFKQ7+Y6cDuj5lKoTyGTXbzbZtuwtHnm/kakQI5/zuaMkbQAyzjfJRM1HbBUvQTD0EpyYgrkFf22p3jbZgJGJCK51bvKooReXaOUOiC72TUl65VePpWS57Qpy/Bwqvsuxoo/Znzt5qIoVC6xir3b0v2P/DyIsuU=
Message-ID: <8bd0f97a0708010204u28caa203qf08452c1bc33a0cb@mail.gmail.com>
Date: Wed, 1 Aug 2007 05:04:28 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1-mm2
In-Reply-To: <20070801081500.GA8723@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070731230932.a9459617.akpm@linux-foundation.org>
	 <20070801062501.GB7581@linux-sh.org>
	 <8bd0f97a0708010058v76f13361q62e79fe39c1f0589@mail.gmail.com>
	 <20070801081500.GA8723@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/07, Paul Mundt <lethal@linux-sh.org> wrote:
> The generic code has a better chance of being merged if it actually works
> at least and doesn't break every platform out there that has an existing
> stub. It offers quite a bit of new functionality and does clean things up
> a bit, so it would certainly be nice to get things to use that, rather
> than having to duplicate all of this crap in the architectures. If it's
> not going to be merged, everyone will of course continue using the
> existing in-tree stubs (sh, ppc, etc.).

ok, ive opened a tracker on our site for this

> It's generally advantageous to get these things working on your
> architecture _before_ things are merged however, as it's one less thing
> to catch up on after the fact. It also helps to figure out if there are
> issues with the current implementation by trying it out on your platform
> in advance, it's a lot more work to push back against it once it's
> already merged.

of course ... but if there isnt a serious chance of this being merged,
then it isnt in our (Blackfin's) interest to investigate it since our
current solution seems to be chugging alone fine
-mike
