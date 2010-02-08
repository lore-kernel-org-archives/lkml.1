Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab0BHSnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 13:43:52 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:64545 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab0BHSnv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 13:43:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=r+JwrAOGZwgB7pa5RFKffkXjOF7C0TfzifhwNllvtvqSBHUS9cqp6cVKTrRLyaqi+0
         NKgyejZjv8ZSaKWdRnrbedhXMgx7AO2HdUhwcGkj918nIxswDT+7vQA1zmboY8trobR+
         bhsxPM/Li1nPshO6oq8iK8jGJMo28xnjxhGOw=
MIME-Version: 1.0
In-Reply-To: <4B7036E5.7050601@gmail.com>
References: <4B7036E5.7050601@gmail.com>
From: roel kluin <roel.kluin@gmail.com>
Date: Mon, 8 Feb 2010 19:43:25 +0100
Message-ID: <25e057c01002081043reb909eet70f6bb86657fbd90@mail.gmail.com>
Subject: Re: FRV: possibly bad unsigned comparison in show_backtrace()
To: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 8, 2010 at 5:08 PM, Roel Kluin <roel.kluin@gmail.com> wrote:
> In arch/frv/kernel/traps.c, show_backtrace(), if sp is 0
> then the dump does not succeed because stop was set to 0
> and unaltered when we reach the unsigned comparison:
>
>  while (tos < stop) {...}

I was mistaken, a while (tos >= stop) won't end

Roel
