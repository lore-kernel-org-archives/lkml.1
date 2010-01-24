Return-Path: <linux-kernel-owner+w=401wt.eu-S1752214Ab0AXSyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab0AXSyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 13:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727Ab0AXSyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 13:54:14 -0500
Received: from mail-ew0-f226.google.com ([209.85.219.226]:59843 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab0AXSyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 13:54:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=aSRYwLKaJbTTALvuRppp3ZDl+hzY4v7EO+rp572TnemnNTJctU9befefbrXLjNd611
         cJjm69wYXM4/XIpyyW9oZ+1Tzsr1v7hW5ruQnXF8Hm36+83EstDIMk9/lzwQg6VbeEed
         IVLD77zaqr+c1ZJVblG+E/S0Zo59zhCTbk6XY=
MIME-Version: 1.0
In-Reply-To: <1264353324.5592.1.camel@wall-e>
References: <1264349038-1766-1-git-send-email-tfransosi@gmail.com>
	 <1264353324.5592.1.camel@wall-e>
Date: Sun, 24 Jan 2010 16:54:11 -0200
Message-ID: <a4c8a6d01001241054q74199217sf94aac668a8454e9@mail.gmail.com>
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

On Sun, Jan 24, 2010 at 3:15 PM, Stefani Seibold <stefani@seibold.net> wrote:
> Am Sonntag, den 24.01.2010, 11:03 -0500 schrieb Thiago Farina:
>> kernel/kfifo.c:83:35: warning: Using plain integer as NULL pointer
>>
>
> I don't know where you get this kind of warning. But passing 0 for a
> NULL pointer is ANSI C standard.

This is a sparse warning. Got with: make C=1.
