Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbYEVRoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbYEVRoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 13:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbYEVRoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 13:44:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52071
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754899AbYEVRoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 13:44:00 -0400
Date: Thu, 22 May 2008 10:43:56 -0700 (PDT)
Message-Id: <20080522.104356.76251548.davem@davemloft.net>
To: schwab@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: Moving include/asm-*
From: David Miller <davem@davemloft.net>
In-Reply-To: <jeve16qoyq.fsf@sykes.suse.de>
References: <je1w3uu5dc.fsf@sykes.suse.de>
	<20080522.091229.229699590.davem@davemloft.net>
	<jeve16qoyq.fsf@sykes.suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Schwab <schwab@suse.de>
Date: Thu, 22 May 2008 18:32:29 +0200

> David Miller <davem@davemloft.net> writes:
> 
> > That doesn't make it any more intuitive.
> 
> Flexibility comes with some cost.

GLIBC is overly flexible, to the point of being painful.

It is designed in such a way that you cannot even do a fully parallel
build.  It can only parallelize in one directory at a time.

It stats files like crazy, in every subdirectory it visits, in order
to implement this prioritization scheme.

It is the most inefficient build system that I am aware of for such an
important code base.
