Return-Path: <linux-kernel-owner+w=401wt.eu-S933178AbYCGJ3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933178AbYCGJ3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765550AbYCGJWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:22:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765499AbYCGJWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:22:46 -0500
Date: Fri, 7 Mar 2008 01:22:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dave Young" <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] add time_after_now and other macros which compare
 with jiffies
Message-Id: <20080307012244.ed7625ec.akpm@linux-foundation.org>
In-Reply-To: <a8e1da0803070112p6a5e076aw569a50a69de91504@mail.gmail.com>
References: <20080307030901.GA4375@darkstar.te-china.tietoenator.com>
	<20080307010228.de6700b5.akpm@linux-foundation.org>
	<a8e1da0803070112p6a5e076aw569a50a69de91504@mail.gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008 17:12:29 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:

> Indeed, I will add proper comment before them.

Sob.  Of the 809 usages of time_after(), it appears that over 700 are
comparing with jiffies.  So with your (good) change, someone will get
buried in well-meaning convert-to-time_after_now patches.

I wonder who that might be?
