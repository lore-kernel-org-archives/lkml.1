Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbZEOMrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbZEOMrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 08:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZEOMro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 08:47:44 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:25389 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZEOMro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 08:47:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=kzNnaXN8sf3AS3d4GmQxmrChPEpEna6iihsu4SXph4YusxEaI5OXpKtDcRXuNDj9cb
         mTVmIeJbLubChmpBxGQipxEeJ9vebzIlgDjqfmJlIP/rZF+xepfqAayHPExgvWgiT4zu
         JEPGmj513WA+vfSEA05ADPaenKnW3tCMZwMFg=
MIME-Version: 1.0
In-Reply-To: <8bfdd4d60905110658g186bc26el703eb1baf076616e@mail.gmail.com>
References: <8bfdd4d60905110658g186bc26el703eb1baf076616e@mail.gmail.com>
Date: Fri, 15 May 2009 08:47:42 -0400
Message-ID: <8bfdd4d60905150547l6a313507g66476e1fa82c3871@mail.gmail.com>
Subject: Re: fixed timeslice
From: Jason mclaughlin <mcjason@gmail.com>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

doesn't it work out that scheduling fairness is accomplished by
ready-to-run and next-in-line?

so when is it the turn to have your next-in-line when you're ready to
run? when something else is done before, right?

so what opportunity does something want to have when it's ready to
run? it's when it comes up in line.
so what is the change of being available to run right away when IO
finishes and you can have your read succeed?
isn't it when something is done before sometimes?

can what's before use as much time as a timeslice though?

ok..

so if so,

isn't it scheduling on-time opportunity that matters the most for IO?

so when a read is successful, it's time to run right away, to do
another read perhaps.

because that's when it's stop-go for IO.

so scheduling can't always make opportunity to run when IO is
successful right? sometimes though.
but isn't what's before that's running now maybe a whole timeslice?
but with the same fairness to run?

can't this make it so IO schedules with a timeslice between stop-go?






On Mon, May 11, 2009 at 9:58 AM, Jason mclaughlin <mcjason@gmail.com> wrote:
> can't scheduling be unfair when a fixed timeslice is used as the time
> up til a process can run?
>
> won't it work out that if a program is using the harddrive, and
> another is using cpu time and using up it's timeslices, that the
> cpu user will give less runtime opportunity to the harddrive user
> because of a wait up until timeslice to use the harddrive again?
>
> like, doesn't the length of a timeslice change the fairness of
> scheduling opportunity for harddrive use?
>
> can't it span the time that something is ready to take from the
> harddrive, til the time the harddrive can be used again?
>
> can't it anyways in some cases though no matter what, because of how
> using up til a timeslice is available sometimes when something wants
> to use the harddrive again,
> and because what wants to use the harddrive can be behind what uses a
> whole timeslice?
>
