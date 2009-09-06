Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbZIFI4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbZIFI4J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 04:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZIFI4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 04:56:08 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:36287 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbZIFI4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 04:56:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=vbJqpAiCb/xM79WQLyJH4INd38zBF2fohyoaN/+v+UGKzpRJsMkR0K10LY+qrzqtgw
         VXkPxt2Rdx7bl4ANHB3Upe86WHdcESVlUJZU0bcj46ztIrxvpy3QP028Gew7ecbSEeNB
         CUOVxHamqsez8igbW6wgZqqmSk8+VpKwGFEnM=
MIME-Version: 1.0
In-Reply-To: <4AA2A257.3000409@ameritech.net>
References: <alpine.DEB.1.10.0908270803540.3447@pc1lin.fred.org> 
	<m3prahctv6.fsf@hase.home> <082720091839.15057.4A96D2D10002C02000003AD122230647029B0A02D2080C0A9B079D0A030EBF9F030E059B070A08@att.net> 
	<a36005b50908271215v27f06476p5808b9fb6b19fa81@mail.gmail.com> 
	<4AA2A257.3000409@ameritech.net>
From: Ulrich Drepper <drepper@gmail.com>
Date: Sun, 6 Sep 2009 01:55:48 -0700
Message-ID: <a36005b50909060155k61129b79iab0a0e6db7008ed2@mail.gmail.com>
Subject: Re: popen2 popen call
To: "F. Heitkamp" <heitkamp@ameritech.net>
Cc: Andreas Schwab <schwab@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 5, 2009 at 10:39, F. Heitkamp<heitkamp@ameritech.net> wrote:
> linux-pipe.c:(.text+0x3b): warning: warning: pipe2 is not implemented and
> will always fail

you will get this warning if the glibc you're using was compiled
without appropriate kernel headers.  I.e., the definition of
__NR_pipe2 wasn't available.
