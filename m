Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbYIFR3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbYIFR3w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbYIFR3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:29:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:47744 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbYIFR3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:29:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UAHKDuPp8OxLO+ZFNDjgC0ci/E8RGkCsCCJ/pBxGjX6ehNezjjcyW+7YqXJsflIDRo
         57mIXyErOwfDxcmtAcBSxVtt5mjgEiVR9ohFIcsLfu5dgbLPQivXsFY+1Aa6xT3OBDa4
         AVU701OOJEIXC0hKQBOqx8J69+cL6bN2dL0kQ=
Message-ID: <68676e00809061029y33d40490pa3d1b2c9a30c3552@mail.gmail.com>
Date: Sat, 6 Sep 2008 19:29:42 +0200
From: "Luca Tettamanti" <kronos.it@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [2.6.27] overlapping early reservations [was: early exception - lockdep related?]
Cc: "H. Peter Anvin" <hpa@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, mingo@redhat.com
In-Reply-To: <20080906172523.GL4856@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <68676e00809051217h3da02a6bld4412b4a2ee3b728@mail.gmail.com>
	 <1220642738.11202.21.camel@twins.programming.kicks-ass.net>
	 <48C19415.9060108@kernel.org>
	 <68676e00809060620k35679302s42fc0a74aa1dc2d3@mail.gmail.com>
	 <20080906145122.GA7693@elte.hu>
	 <68676e00809061020y440d4c14ye76413d1e0e57e38@mail.gmail.com>
	 <20080906172523.GL4856@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 6, 2008 at 7:25 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Luca Tettamanti <kronos.it@gmail.com> wrote:
>
>> > or perhaps something made your v2.6.27 bzImage larger so that the
>> > overlap happens - while it didnt before.
>>
>> The compressed image (bzImage) is roughly the same size as older
>> kernels (2MB), the uncompressed vmlinux is slightly bigger, but not
>> much (~100k)
>
> hm, that doesnt seem to match the ranges that got printed:

Sorry, the sentence above is not very clear: I meant that with 2.6.27
the uncompressed vmlinux is only slightly bigger than older kernels;
as you stated the size is 11.6MB.

Luca
