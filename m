Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbYHFDwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbYHFDwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 23:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYHFDwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 23:52:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43044 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbYHFDwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 23:52:20 -0400
Date: Wed, 6 Aug 2008 05:52:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eric Paris <eparis@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/5] [TALPA] Intro to a linux interface for on access scanning
Message-ID: <20080806035255.GC24801@one.firstfloor.org>
References: <1217883616.27684.19.camel@localhost.localdomain> <874p5y7tw0.fsf@basil.nowhere.org> <1217994234.27684.227.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217994234.27684.227.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I didn't consider it.  Most likely at the end of the day the finding
> will be, "if you can write directly to the block device you already won
> since there as so many other things you can do to subvert the system."

This means your scheme is not generally supposed to protect against root? 

I assume yes (since I can think of lots of other holes for 
root), but you should state that explicitely in the spec since it
is a major limitation.

On the other hand it will also allow you to optimize significantly:

In particularly it also means that you can trust the permissions
and don't need to check any files which cannot be written by users 
you don't control.

-Andi

