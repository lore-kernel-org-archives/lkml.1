Return-Path: <linux-kernel-owner+w=401wt.eu-S933854AbZKXSRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933854AbZKXSRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933875AbZKXSRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:17:07 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:34390 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933867AbZKXSRE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:17:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=HKXS+SBsTAkYKFZFuA42SIk0meK/tSuPZWutLwYh5QvpP34uO3v03bjkSXZedJ2x/Z
         V7loKQB8BcQ21R3vFwoTI5EzqSTpWFqIUq7zN5DZQertJ8YW/SGvrQLIi35Q4qKIKEvm
         76Lw66Ud5WWQvQDRJ5qHOp+gy+BVUMswZCSD0=
MIME-Version: 1.0
Reply-To: aaron@assonance.org
In-Reply-To: <73c1f2160911240950u7256feedqc475fa915dda43ca@mail.gmail.com>
References: <4B0BBB83.2020604@klingt.org>
	 <73c1f2160911240950u7256feedqc475fa915dda43ca@mail.gmail.com>
Date: Tue, 24 Nov 2009 13:17:09 -0500
Message-ID: <727e50150911241017h4bb1c0aex800e8c0ef7eee9fd@mail.gmail.com>
Subject: Re: [PATCH 0/5] branch hint tweaks
From: Aaron Cohen <remleduff@gmail.com>
To: Brian Gerst <brgerst@gmail.com>
Cc: Tim Blechmann <tim@klingt.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 12:50 PM, Brian Gerst <brgerst@gmail.com> wrote:
> On Tue, Nov 24, 2009 at 5:54 AM, Tim Blechmann <tim@klingt.org> wrote:
>> hi all,
>>
>> doing some branch hint profiling of 2.6.31 on my nehalem machine showed
>> a few
>> incorrect branch hints.
>> these patches remove or change the branch hints
>
> I'm not sure what version of GCC added this, but I wonder if this
> option will fix the problem:
>
> -fno-guess-branch-probability
>    Do not guess branch probabilities using heuristics.
>
>    GCC will use heuristics to guess branch probabilities if they are
> not provided by profiling feedback (-fprofile-arcs). These heuristics
> are based on the control flow graph. If some branch probabilities are

Is the kernel's use of unlikely typically intended to mean "I consider
the following unlikely so please optimize with that expectation" or is
meant to indicate "the following is a slow-path so please pessimize
it" or both?
