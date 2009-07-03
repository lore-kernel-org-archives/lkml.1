Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbZGCApw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbZGCApw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 20:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbZGCApp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 20:45:45 -0400
Received: from mail-vw0-f202.google.com ([209.85.212.202]:54860 "EHLO
	mail-vw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbZGCApo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 20:45:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ER4yZxbBIHcdPOwfHydWKPy35usA9szTrOpIby3H10GAm1z2R5QGTyuZyA61E1HI5f
         iHyrN4zDqqlJQM4i+IisIHZ8oVX2kqr9C61LW6g9Bgp+xVx2kJ9r9fwdEHxZEABslyiP
         SSgjfCOZXp4727TAYbrLKRx7ER8exlAmGvbNA=
MIME-Version: 1.0
In-Reply-To: <20090702114207.58724071@lxorguk.ukuu.org.uk>
References: <412e6f7f0907020036y76abbc7du99c7b695f725be4@mail.gmail.com>
	 <20090702091309.GB6372@cr0.nay.redhat.com>
	 <412e6f7f0907020218m1f4a9651l2c682a9905925bcd@mail.gmail.com>
	 <20090702114207.58724071@lxorguk.ukuu.org.uk>
Date: Fri, 3 Jul 2009 08:45:47 +0800
Message-ID: <412e6f7f0907021745k41e5c7aeua35200d5047c1aa@mail.gmail.com>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
From: Changli Gao <xiaosuo@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 6:42 PM, Alan Cox<alan@lxorguk.ukuu.org.uk> wrote:
> On Thu, 2 Jul 2009 17:18:49 +0800
> Changli Gao <xiaosuo@gmail.com> wrote:
>
>> On Thu, Jul 2, 2009 at 5:13 PM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
>> > On Thu, Jul 02, 2009 at 03:36:41PM +0800, Changli Gao wrote:
>> >
>> > Why? Why do you need this feature?
>> >
>> Are you familiar with splice() and tee()? They both use pipes as kernel buffers.
>
> And are being used quite happily with the pipe() call. So what is the
> problem ?
>
No problem! But I just want to save a fd. As one RW pipe fd is enough
for splicing.



-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
