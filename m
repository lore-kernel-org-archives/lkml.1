Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbZJSPxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbZJSPxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbZJSPxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:53:22 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:36075 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbZJSPxV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:53:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nkJZqfHz2dIGtGJF7+1F44z47dq9YiiyM3G2jIA971CUKi6sXoJqCT9S3+CV/8dhxK
         KSc9TYtQybp5A5GEGZkpafLj2jIGcefmjbdZHqKEs6odzYqeA3aw4s0jRHq3cVr/R2nN
         Sq/CjWl1JACyUD+ivFyBUEVbrBAYd9uGYsgAo=
MIME-Version: 1.0
In-Reply-To: <1255939868-5050-1-git-send-email-mcree@orcon.net.nz>
References: <1255939868-5050-1-git-send-email-mcree@orcon.net.nz>
Date: Mon, 19 Oct 2009 11:53:25 -0400
Message-ID: <b4198de60910190853k54267f9flcf6453d6e23f6da3@mail.gmail.com>
Subject: Re: Unimplemented syscalls on Alpha
From: Matt Turner <mattst88@gmail.com>
To: Michael Cree <mcree@orcon.net.nz>
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 4:11 AM, Michael Cree <mcree@orcon.net.nz> wrote:
> I couldn't but help notice the increasing number of unimplemented syscalls
> on the Alpha architecture.  I thought I might poke around to see what might
> be required to get these implemented and got a pleasant surprise when it
> seems some only need an entry in the syscall table.  Indeed, the patch in
> reply to this message gets preadv and pwritev going -- tested with the
> sample program at http://lkml.org/lkml/2009/4/6/535.

Cool. I was looking into doing this, but I didn't know how to test the syscalls.

I tried to keep a list of missing syscalls here,
http://alphalinux.org/wiki/index.php/TODO_List but as you can see it's
already out of date.

> I am happy to write patches to wire up more of the syscalls, but I am
> wondering which ones are as straightforward as the preadv/pwritev case?
> That is, do any require extra programming other than the syscall table?  Do
> I need to get the entries in the syscall table in the same order as other
> architectures?

I'm curious and unsure about this too. Patches would be great. I think
we should figure out who we need to CC to get patches into the kernel,
as neither of our maintainers have any sort of Alpha tree. I've
noticed a few patches submitted to this list have never made it into
the kernel, as well, maybe we should start an alpha tree?

The entries do not need to be in the same order of have the same
number as other architectures, just once you set the number you cannot
change it (without breaking the ABI).

Thanks Michael,
Matt
