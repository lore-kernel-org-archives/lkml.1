Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403Ab0A0BjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab0A0BjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 20:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106Ab0A0BjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 20:39:18 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:46747 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0A0BjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 20:39:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GciInKW8+ijXL4Ox288MV6luP5gwGvugiBe4OdtFsxO6iZfT/skn0XNuemoMwuMHNn
         jhrkedE1BCeKVM/s8NWKJ9XcagvgHQgBXb4pprh0VsgMYBe8F3rXq0sanuIoO7w2eZFI
         bwoexUnApw7J8ni992FdXiOT9RKtqRsG/Ajlw=
MIME-Version: 1.0
In-Reply-To: <1264353324.5592.1.camel@wall-e>
References: <1264349038-1766-1-git-send-email-tfransosi@gmail.com>
	 <1264353324.5592.1.camel@wall-e>
Date: Tue, 26 Jan 2010 23:39:16 -0200
Message-ID: <a4c8a6d01001261739x2ea25aeev3d5fe596169c7d74@mail.gmail.com>
Subject: Re: [PATCH 1/4] kernel/kfifo.c: fix "interger as NULL pointer" 
	warning.
From: Thiago Farina <tfransosi@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefani,

On Sun, Jan 24, 2010 at 3:15 PM, Stefani Seibold <stefani@seibold.net> wrote:
> Am Sonntag, den 24.01.2010, 11:03 -0500 schrieb Thiago Farina:
>> kernel/kfifo.c:83:35: warning: Using plain integer as NULL pointer
>>
>
> I don't know where you get this kind of warning. But passing 0 for a
> NULL pointer is ANSI C standard.

NACK?
