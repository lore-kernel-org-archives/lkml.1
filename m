Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab0BXF2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 00:28:47 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:61126 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab0BXF2q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 00:28:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kVFRk8WaoQuOe67dzO69lzSnvHwxRqNpUsQTyEDT+or7cbbKQ9VGz/djJe/Abk2k6u
         WSf6DELCUf4QQE9yakh3PDMrv0PSO7aZbBL89VCM1XdrrNxFIQa+FL2tu4ygLWWQaJsr
         VMOjOpXPaVjLYkJWqOwnSpXZbh41ylfr1WT8A=
MIME-Version: 1.0
In-Reply-To: <201002231758.17454.arnd@arndb.de>
References: <912ec82a1002230847h11d0f628rbd38b12f38270735@mail.gmail.com>
	 <201002231758.17454.arnd@arndb.de>
Date: Wed, 24 Feb 2010 07:28:44 +0200
Message-ID: <912ec82a1002232128y5ac10c0bpf38e46f6c2d20872@mail.gmail.com>
Subject: Re: sysfs vs. ioctl
From: Neshama Parhoti <pneshama@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 6:58 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> One rule of thumb is that if you already require a character device, using ioctl
> is the right answer, but you shouldn't create a character device
> if all you want to do over it is a single ioctl operation.

thank you so much this really helped !

~pnesh

>
>        Arnd
>
