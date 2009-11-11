Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbZKKBDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbZKKBDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 20:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbZKKBDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 20:03:45 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:45658 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117AbZKKBDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 20:03:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type;
        b=w7D5XRKzemCYlDDS+yX/cB0o6S+1rOL0YsXJQXx+YjsXY2Wqhd60OyCydANAuOWmbt
         v5cJiWQRkLS05qNA69a0nTdI0sv38XD4wRjQrnJiEY2sUQqXQ5qBl6cyNsTd+2lgEFgI
         ktDswwKQ9WD4+qeWnYHV9OicV+Bv3p4ffdFX0=
MIME-Version: 1.0
In-Reply-To: <43e72e890911101701g4250f59ar73a929114e21ae2e@mail.gmail.com>
References: <43e72e890911101701g4250f59ar73a929114e21ae2e@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 10 Nov 2009 17:03:30 -0800
Message-ID: <43e72e890911101703k2c500681t7b18aec03c194be3@mail.gmail.com>
Subject: Re: lpj=x loops_per_jiffy option enhancements
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 5:01 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> The lpj argument seems nice but it seems busted for SMP. I was
> wondering since this is a common thing for some embedded devices can't
> we just stuff the lpj somewhere after our first boot and remove this
> as an option?
>
> Where we store it ? I don't know... we managed to store an image for
> suspend, seems we can find a place for lpj, no?

And only do it for UP boxen, and *always* do it for them. Or is the
lpj expected to change over time on a box?

  Luis
