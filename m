Return-Path: <linux-kernel-owner+w=401wt.eu-S1760966AbYEBG4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760966AbYEBG4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 02:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760346AbYEBGzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 02:55:52 -0400
Received: from ns1.suse.de ([195.135.220.2]:38051 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759254AbYEBGzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 02:55:51 -0400
From: "NeilBrown" <neilb@suse.de>
To: "Andrew Morton" <akpm@linux-foundation.org>
Date: Fri, 2 May 2008 16:55:43 +1000 (EST)
Message-ID: <53722.192.168.1.70.1209711343.squirrel@neil.brown.name>
In-Reply-To: <20080501215231.297e0d9d.akpm@linux-foundation.org>
References: <18456.34604.472989.35082@ipc1.ka-ro>
    <20080501215231.297e0d9d.akpm@linux-foundation.org>
Subject: Re: linux-2.6.25: 'mkdir -p' does not work with rootdir as mount 
     point inside a read only filesystem
Cc: Lothar =?iso-8859-1?Q?Wa=DFmann?= <lw@karo-electronics.de>,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.13
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2008 2:52 pm, Andrew Morton wrote:
> On Wed, 30 Apr 2008 16:50:20 +0200 Lothar Wa__mann
> <LW@KARO-electronics.de> wrote:
>
>> Hi,
>
> (y'know that ~4000 people read your email and hit 'n'?  Except for me?
> That's one bug I'd like to get fixed)

Tricky....

>
>> when trying to create a directory path with 'mkdir -p' with the root
>> being a mount point of a writeable filesystem that exists inside a
>> read-only file system, mkdir return -EROFS.

My guess is that you have an old/buggy version of mkdir.

What does
    mkdir --version

say?
Mine says:
mkdir (GNU coreutils) 6.10
Copyright (C) 2008 Free Software Foundation, Inc.
etc...

What does

   strace mkdir -p /dev/.udev/db

show ???

NeilBrown


