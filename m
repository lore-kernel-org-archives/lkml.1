Return-Path: <linux-kernel-owner+w=401wt.eu-S1752648AbYKAQIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbYKAQIU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 12:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbYKAQIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 12:08:11 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:27852 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbYKAQIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 12:08:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=nD8Xg9NZjMxHiG8955F9RYrHnT7z5tAlO7A5dafp/frDwkKIPj5rLjb95F4E6H944t
         IjoW77yg2BckCVvUaR9hqr31+K4kdijHnlZAu6gVdacZWCGoWle5gi5UUPb3mqiZWkJV
         1BqicXaAbTRjhCWLAKlGeNP/xw53zvekmr+qo=
Message-ID: <84144f020811010908h1220d209j799edca3eb772fd@mail.gmail.com>
Date: Sat, 1 Nov 2008 18:08:09 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
Subject: Re: [linux-dvb] [PATCH 1/7] Adding empia base driver
Cc: "Hans Verkuil" <hverkuil@xs4all.nl>,
       "Markus Rechberger" <mrechberger@gmail.com>,
       v4l <video4linux-list@redhat.com>, linux-dvb@linuxtv.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>, "Greg KH" <greg@kroah.com>,
       mchehab@infradead.org
In-Reply-To: <412bdbff0811010846h2edd63bfn44536e8a1c72d17f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200811011505.51716.hverkuil@xs4all.nl>
	 <412bdbff0811010846h2edd63bfn44536e8a1c72d17f@mail.gmail.com>
X-Google-Sender-Auth: 4ec5139467b15c0e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Devin,

On Sat, Nov 1, 2008 at 5:46 PM, Devin Heitmueller
<devin.heitmueller@gmail.com> wrote:
> A number of people have suggested that nobody was willing to
> incorporate Markus's changes incrementally to improve the in-kernel
> driver.  This couldn't be further from the truth.  I appealed to
> Markus on multiple occasions trying to find some compromise where his
> changes could be merged into the mainline em28xx driver.  He outright
> refused.  It was his contention that his driver was/is better than the
> in-kernel driver in every possible way, and that the existing code has
> no redeeming value.  In fact, I was accused of taking his GPL'd code
> without his consent and incorporating it into the linux-dvb codebase.
> It's this "all or nothing" attitude that has prevented his work thus
> far from being incorporated, not the unwillingness of people like
> myself to do the work to merge his changes in a sane matter.

I'm not sure I understand how he can refuse such a thing. If the code
is released under the GPLv2 and the author refuses to play by the well
known rules of the kernel community, then I don't see any problem with
taking the code and improving the current driver (as long as the
copyright is properly attributed, of course).

I think it's already pretty well established that we don't just take
in shiny new drivers and trust a new maintainer to do the right thing
because that has gotten us in such a mess so many times before. Being
part of the community is not so much the code you write but the way
you interact with other kernel developers.

So, if I were you, I'd just do it.

                        Pekka
