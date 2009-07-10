Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbZGJWbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbZGJWbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 18:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbZGJWb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 18:31:28 -0400
Received: from mail-pz0-f197.google.com ([209.85.222.197]:54981 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbZGJWb1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 18:31:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cznS9mV5bLojIaYVqzlJjyOnoF+8UwuLOLgVId4LnmPqyKmHnMfmdF2wACUwdi/9oY
         GskV5nlJC0h7mhbNLkDpU1EOokouzKidB+5xXeqoT8xC8Uv3cscYNqlkOhXkUyWOyHU7
         19i+tS9Ca/UqwHp0OUC1+wJJf7dTXcDLBmHiw=
MIME-Version: 1.0
In-Reply-To: <4A57BD9B.4030405@acm.org>
References: <4A57BD9B.4030405@acm.org>
From: David Rees <drees76@gmail.com>
Date: Fri, 10 Jul 2009 15:31:06 -0700
Message-ID: <72dbd3150907101531v623bb584r46f05bfab8d0d3ff@mail.gmail.com>
Subject: Re: make xconfig fails on Fedora 10 for 2.6.30
To: Wayne Pollock <pollock@acm.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 3:15 PM, Wayne Pollock<pollock@acm.org> wrote:
> The work-around was to manually create the missing symlink
> for "libXi.so".  I suspect other distro's install that
> symlink automatically so maybe that's why the bug was
> not discovered.  But I believe it is correct to say all
> applications should use a soname (including the major
> version number), and not just the "linker" name (the
> name ending in ".so" with no version numbers).
>
> Or am I missing something?

ldconfig should create those symlinks for you automatically.  Unless
it's looking for the 32-bit version for some reason and you have a
64-bit system.  Then there's something else going on...

-Dave
