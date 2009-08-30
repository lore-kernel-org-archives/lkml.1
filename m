Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348AbZH3LMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbZH3LMn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 07:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbZH3LMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 07:12:42 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:57354 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbZH3LMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 07:12:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=lxdXkr+TkbGb90zeWv/zbMoSWRFKBfm+4B+kwKoEUuyD8D0m5Suyp6Fhkvalzc/Dg/
         9vZagfoon7oM30MZmwmfo1mD6Q2IOT4gSMvRF/Iqyu49PCNYv14eSpn/WIX9fMtS5oWw
         ctc2Cl2weD4WebWwSnvMPlvajPI1+CvkTn4IY=
MIME-Version: 1.0
In-Reply-To: <4A9285FC.8000606@byu.net>
References: <4A9285FC.8000606@byu.net>
Date: Sun, 30 Aug 2009 12:12:42 +0100
X-Google-Sender-Auth: 5e1471e5ce05cb2c
Message-ID: <c5df85930908300412lc2f334dle4502492b25827f5@mail.gmail.com>
Subject: Re: [RFC] new open flag O_NOSTD
From: James Youngman <jay@gnu.org>
To: Eric Blake <ebb9@byu.net>
Cc: linux-kernel@vger.kernel.org, bug-coreutils <bug-coreutils@gnu.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 1:22 PM, Eric Blake<ebb9@byu.net> wrote:
> The name proposed in this mail is O_NOSTD (implying that a successful
> result will not be any of the standard file descriptors); other ideas
> mentioned on the bug-gnulib list were O_SAFER, O_NONSTD, O_NOSTDFD.
> http://lists.gnu.org/archive/html/bug-gnulib/2009-08/msg00358.html
>
> Thoughts?

Mostly yes,  I like it.

I'd like to explicitly vote against O_SAFER, because there may be (for
some systems or in the future) some other way of making open(2) safer.
  I'd vote positively for O_NOSTDFD or O_NOSTD.

James.
