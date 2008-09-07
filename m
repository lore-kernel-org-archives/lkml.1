Return-Path: <linux-kernel-owner+w=401wt.eu-S1755747AbYIGQag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbYIGQag (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 12:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbYIGQa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 12:30:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36453 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbYIGQa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 12:30:28 -0400
Message-ID: <48C40191.8070208@zytor.com>
Date: Sun, 07 Sep 2008 09:30:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>
CC: Steven Noonan <steven.noonan@uplinklabs.net>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: bzip2 or lzma -compressed kernels and initrds
References: <200809062119.m86LJ5Of026101@hitchhiker.org.lu>	 <48C34803.60006@zytor.com> <1a6b76aa0809062135n4d0710c7sf7332d6b4e63cdad@mail.gmail.com> <48C35CA9.4010205@zytor.com> <48C38571.7060808@knaff.lu>
In-Reply-To: <48C38571.7060808@knaff.lu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alain Knaff wrote:
> 
> Could you elaborate please?
> 

At a brief glance, there is an awful lot of #ifdefs in that code, a lot 
of which look unnecessary.  #ifdefs make the code hard to read, and 
usually signify that additional abstractions are called for.

	-hpa
