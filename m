Return-Path: <linux-kernel-owner+w=401wt.eu-S939268AbZDJRxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939268AbZDJRxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764532AbZDJRxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:53:44 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:56751 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759620AbZDJRxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:53:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=WRKcjb9ij7Ez+sTtFmzpGaMJ5Zw6uxKTmKAHVzvXQh4U612Q+hZxqJ8vPkqQyxeiMk
         Aw7qoVfHSUn9IPQ4Dcv4oIh2sKBq5pvVM9TWqilQYvjSSvRooGBcjRHBnaUulrGb63XQ
         YeonB/VXgEi8CHEIY8H8r+IQSr0fP98z2SJLk=
MIME-Version: 1.0
In-Reply-To: <1239385015.3169.15.camel@ht.satnam>
References: <1239385015.3169.15.camel@ht.satnam>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Fri, 10 Apr 2009 10:53:27 -0700
X-Google-Sender-Auth: e72c7ea77aa145c5
Message-ID: <2c0942db0904101053g3a7a3d6bh50c0501a1bb73af@mail.gmail.com>
Subject: Re: [PATCH -tip] x86: acpi/sleep.c saved_magic fix overflow
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 10:36 AM, Jaswinder Singh Rajput
<jaswinder@kernel.org> wrote:
> Impact: fix overflow
>
> Constant 0x123456789abcdef0 is so big for a long.
> So using saved_magic 0x12345678 for both 32 and 64 bit.
>

Uhm, what? saved_magic is a long, which is 64 bits wide on on 64 bit systems.
