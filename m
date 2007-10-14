Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbXJNN3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbXJNN3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 09:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbXJNN3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 09:29:04 -0400
Received: from rtr.ca ([76.10.145.34]:4175 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686AbXJNN3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 09:29:03 -0400
Message-ID: <4712199D.6090409@rtr.ca>
Date: Sun, 14 Oct 2007 09:29:01 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: vignesh babu <vigneshbabu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: wierd file perms
References: <3d1754a30710131010h5d3cbb28tfeb8b4228a448f2e@mail.gmail.com>
In-Reply-To: <3d1754a30710131010h5d3cbb28tfeb8b4228a448f2e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vignesh babu wrote:
..
> ?--------- ? ? ? ?                ? fcntl.c
> ?--------- ? ? ? ?                ? fifo.c
> ?--------- ? ? ? ?                ? filesystems.c
> ?--------- ? ? ? ?                ? file_table.c
> ?--------- ? ? ? ?                ? freevxfs
> 
> So end result is that, Im not able to delete the files or change perms
> or ownership even as root.
> 
> Can some one help please?

chmod a+x name_of_directory

Now you can do "ls -l" and "rm" or whatever.

