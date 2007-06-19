Return-Path: <linux-kernel-owner+w=401wt.eu-S932701AbXFSTHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbXFSTHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764508AbXFSTHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:07:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59902 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764352AbXFSTHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:07:16 -0400
Date: Tue, 19 Jun 2007 12:06:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: John Stoffel <john@stoffel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, tim.c.chen@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: Change in default vm_dirty_ratio
In-Reply-To: <alpine.LFD.0.98.0706191201130.3593@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0706191205410.3593@woody.linux-foundation.org>
References: <1182201271.4883.22.camel@localhost.localdomain>
 <20070618164711.9de1c38e.akpm@linux-foundation.org> <18040.9056.755569.67029@stoffel.org>
 <alpine.LFD.0.98.0706191201130.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Jun 2007, Linus Torvalds wrote:
> 
> Yes. It should depend on:
>  - speed of the device(s) in question

Btw, this one can be quite a big deal. Try connecting an iPod and syncing 
8GB of data to it. Oops.

So yes, it would be nice to have some per-device logic too. Tested patches 
would be very welcome ;)

		Linus
