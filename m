Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbYGHAMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbYGHAMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 20:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbYGHAMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 20:12:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49185 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbYGHAMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 20:12:45 -0400
Date: Tue, 8 Jul 2008 02:25:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Max Asbock <masbock@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [0/9] Use 64bit x86 machine check code for 32bit too
Message-ID: <20080708002511.GA9366@one.firstfloor.org>
References: <200807041120.678642023@firstfloor.org> <48728A0E.7010802@kernel.org> <48728C81.7080708@kernel.org> <1215475215.6036.10.camel@w-amax.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1215475215.6036.10.camel@w-amax.beaverton.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> However it turns out the build warnings about 
> "mce_64.c:822: warning: passing argument 2 of ‘strict_strtoull’ makes
> integer from pointer without a cast"
> are justified. It looks like strict_strtoull has the last two arguments
> switched with respect to simple_strtoull. You get a NULL pointer
> dereference as soon as you write to one of the machinecheck sysfs
> control files.

Yes, shutting up checkpath's blatterings without full retesting was a 
mistake.  I fixed that in the last iteration I posted earlier.

-Andi

