Return-Path: <linux-kernel-owner+w=401wt.eu-S1765235AbYAaHGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765235AbYAaHGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 02:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbYAaHGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 02:06:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbYAaHGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 02:06:16 -0500
Message-ID: <47A17362.6060106@redhat.com>
Date: Thu, 31 Jan 2008 02:06:10 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Strange error?
References: <200801310028.14259.gene.heskett@gmail.com>
In-Reply-To: <200801310028.14259.gene.heskett@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> Greetings all;
> 
> This line showed up in my log a couple of hours ago, several minutes removed 
> from anything else I was doing at the time:
> 
> rarian-sk-get-c[31855]: segfault at 00000000 eip 00b7c153 esp bf9ddf0c error 4
> 
> The system acts and feels normal.
> 
> Does anyone have a clue to loan me?

I would ask the rarian developers:

http://rarian.freedesktop.org/

My barely-educated guess is that Gnome was doing a routine re-index of 
its help files and and the app got bored and decided to dereference a 
NULL pointer for fun.  Your desktop documentation index may be 
incomplete or corrupt.  Try not to panic.

	-- Chris
