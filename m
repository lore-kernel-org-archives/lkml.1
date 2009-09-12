Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415AbZILR20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbZILR20 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 13:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZILR2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 13:28:21 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:43167 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbZILR2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 13:28:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=reUa2jAnYXT6xmpVCNyL+d2P8eT408N4X6bk6VncgGJWBEhTEs6Hr8C2BxkepZ5am7
         KJ4pfnFfBYAHM+cOYHE8vViOiohFJalUETafUop/wrnzMaasGWefaKKCuidk73iFMVPN
         gtYHrA5hIlShTMVso+Awn3q8LVzRehDIghtkE=
MIME-Version: 1.0
In-Reply-To: <49f90a800909112201v7853be05mbd678dcb5fd20c5a@mail.gmail.com>
References: <25410990.post@talk.nabble.com> <3e8340490909112037p3b4d4f32p2dc6dda01cfcb8ea@mail.gmail.com> 
	<49f90a800909112201v7853be05mbd678dcb5fd20c5a@mail.gmail.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Sat, 12 Sep 2009 13:28:03 -0400
Message-ID: <3e8340490909121028g67b63fadh8d37a975da34c18f@mail.gmail.com>
Subject: Re: Controlling memory allocation
To: Siddhartha Chhabra <siddhartha.chhabra@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 12, 2009 at 1:01 AM, Siddhartha Chhabra
<siddhartha.chhabra@gmail.com> wrote:

> I hope I am making some sense, so in essence my question can be re-framed
> as, can the kernel "virtualize" memory for a particular process so only a
> particular region of the memory is available for that particular process and
> all other activities like page allocation and replacement take place for
> this process only within this region and rest of the system functions
> normally with the entire memory available for use
>
> Thanks once again for your reply and I really appreciate all the help

I'm not an expert on the Linux memory manager, but I don't think what
you're asking has been implemented in the kernel - although it might
be useful for your particular research, it's not really useful in the
real world, so nobody's had a need to implement it. Of course, feel
free to do so yourself :)

PS -  I received two copies of the message with different message IDs.
When replying to this message, just use reply to all from gmail, don't
copy and paste it into nabble as well. The CC will make sure it gets
to lkml.
