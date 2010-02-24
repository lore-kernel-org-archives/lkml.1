Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab0BXE2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 23:28:08 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44273 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab0BXE2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 23:28:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dKYVIGAVvzjr00U9iVUReRkGsLi49INaMZSsr09tS4HIWzSvbYqqH5lbES4+i8PsoT
         AWr9+ZW2O6orGjrjXjLMJ3ZBLcoUY0e8yFZPcQNLY+SjwvqBPNaAsD3WsYjAKwiGFkeq
         frbxch8lTVfc+JXIBIBudY9rLOQQJx3h5po/Q=
MIME-Version: 1.0
In-Reply-To: <07BBC9AE-C1A1-449F-AE5E-EB5B1C6323C2@mit.edu>
References: <22dbbef21002222241h711402f1me6b60ac7502cccd4@mail.gmail.com>
	 <22dbbef21002222243s7afb8e2cy1c783a29fe22ac55@mail.gmail.com>
	 <20100223065953.GB32503@liondog.tnic>
	 <22dbbef21002222331o6a59dc25mea3fc7e62dae6710@mail.gmail.com>
	 <20100223095025.GA18559@liondog.tnic>
	 <22dbbef21002230337i104c63dcm5d59064ca48a07f0@mail.gmail.com>
	 <07BBC9AE-C1A1-449F-AE5E-EB5B1C6323C2@mit.edu>
Date: Wed, 24 Feb 2010 09:58:04 +0530
Message-ID: <22dbbef21002232028i705cee09ic50f30bf830e373@mail.gmail.com>
Subject: Re: QUERY: Inclusion of header files in kernel header files
From: viresh kumar <viresh.linux@gmail.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Borislav Petkov <petkovbb@googlemail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Before someone goes crazy and starts sending hundreds of patches to the trivial patch folks,
> please make sure that you only do this for places where header file foo uses "struct bar" in
>bar.h --- and NOT if it is using "struct bar *".    Blind structure pointers don't cause compile
>failures, and is a perfectly good thing from the standpoint of data hiding.
>

Ted,
Actually bus.h is using direct instances of these structures and thus
it is giving compilation warnings.


viresh.
