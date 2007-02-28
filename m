Return-Path: <linux-kernel-owner+w=401wt.eu-S932253AbXB1SjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253AbXB1SjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 13:39:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932247AbXB1SjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 13:39:05 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38553 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932249AbXB1SjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 13:39:03 -0500
Date: Wed, 28 Feb 2007 10:39:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] HID and USB HID update for 2.6.21-rc2
In-Reply-To: <Pine.LNX.4.64.0702281922110.4255@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0702281038120.12485@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702281114420.4255@jikos.suse.cz>
 <Pine.LNX.4.64.0702280903010.12485@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702281814380.4255@jikos.suse.cz>
 <Pine.LNX.4.64.0702280931480.12485@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702281837200.4255@jikos.suse.cz>
 <Pine.LNX.4.64.0702281013190.12485@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702281922110.4255@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Feb 2007, Jiri Kosina wrote:
> 
> I still think that creating a separate header file solely for purpose of 
> having the large hid blacklist and all related defines separate from the 
> actual implementation is needed. The pages and pages of blacklist just 
> pollute the hid-core.c needlessly. 

BUT IT IS NOT A HEADER FILE!

Dammit!

If it has real code or data in it, it's a .c file, and you don't #include 
it, you *compile* it and you *link* it.

			Linus
