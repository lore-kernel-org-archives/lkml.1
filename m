Return-Path: <linux-kernel-owner+w=401wt.eu-S1759174AbZLOEDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbZLOEDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756695AbZLOEDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:03:10 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:38408 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639AbZLOEDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:03:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=cYWkYwuIQ/TUlcY3Lk0tv9zxIgOkbnRe2ibavRVs+bxHOih5p2EQQQjKia9/geuEvT
         b/bMP62qDaAquH7HkvhCGc1/FGCKnDt/AuYs6GS4G6qLA1Zny9KXGNCK67gE7uCyc0Y5
         r1xsA2jlz3uzPEnIc0YhBv+iAtBmXBStKJmmI=
MIME-Version: 1.0
In-Reply-To: <1260065000-5573-1-git-send-email-jdm64@gawab.com>
References: <1260065000-5573-1-git-send-email-jdm64@gawab.com>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Mon, 14 Dec 2009 20:02:47 -0800
X-Google-Sender-Auth: 58b4f9f728fa89f0
Message-ID: <2c0942db0912142002p638a187araa837812862e5b17@mail.gmail.com>
Subject: Re: [PATCH] staging: s5k3e2fx.c: reduce complexity by factoring
To: Justin Madru <jdm64@gawab.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 5, 2009 at 6:03 PM, Justin Madru <jdm64@gawab.com> wrote:
> I was style fixing some code when I ran into this code.
> It seems like the code could be reduced, by factoring the expression.
> But this results in a very simple expression.
>
> Am I assuming something wrong? Or is this a bug in the original code?
> This doesn't look right because the assignment of s_move[i] has no mention
> of the loop counter.

Algebraic factoring is not valid in general when dealing with pure
integer expressions that may contain rounding issues. I haven't
checked to see if that's the case with the code you're changing, but
that sort of expression you're removing is very commonly used exactly
to deal with rounding issues.
