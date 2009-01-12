Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbZALI2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbZALI2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 03:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbZALI17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 03:27:59 -0500
Received: from ik-out-1112.google.com ([66.249.90.179]:16014 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbZALI16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 03:27:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=uUFLp1FtehxQGKbQwxKlMp4l0LFq9jIwCkHXqh+Qa46D2ex0APcLSJFnjMUruXhcLg
         HJGCKoIn9lQ/e2ojBiGhjKEwu/vfkrwdMhiCAn4txKFj+t1510a3KsusfViTWTcVz/Zc
         2apEiUR9/BBgtG7YBVyENU5FTh/fZY9DmJEj0=
To: "Mark A. Miller" <mark@mirell.org>
Cc: "Bernd Petrovitsch" <bernd@firmix.at>,
       "Leon Woestenberg" <leon.woestenberg@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>, "Rob Landley" <rob@landley.net>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Embedded Linux mailing list" <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
References: <200901020207.30359.rob@landley.net>
	<c384c5ea0901031454n451bc899w166bb146c96f6164@mail.gmail.com>
	<495FEEAF.5020005@zytor.com> <200901032006.47652.rob@landley.net>
	<20090104030619.GA21466@linux-sh.org>
	<c384c5ea0901040223l6e53f041s9f7cdea20c9d1d8d@mail.gmail.com>
	<1231677939.3517.5.camel@gimli.at.home>
	<31014a580901111936q41486efagcb90af2b6880a470@mail.gmail.com>
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Mon, 12 Jan 2009 09:27:32 +0100
In-Reply-To: <31014a580901111936q41486efagcb90af2b6880a470@mail.gmail.com> (Mark A. Miller's message of "Sun\, 11 Jan 2009 21\:36\:58 -0600")
Message-ID: <873afpj5e3.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mark" == Mark A Miller <mark@mirell.org> writes:

 Mark> And for H. Peter Anvin, before you refer to such uses as compiling the
 Mark> kernel under a native environment as a "piece of art", please be aware
 Mark> that the mainstream embedded development environment, buildroot, is
 Mark> also attempting to utilize QEMU for a "sanity check" on the
 Mark> environment.

That's for verifying that the rootfs'es actually work, not for
building stuff.

-- 
Bye, Peter Korsgaard
