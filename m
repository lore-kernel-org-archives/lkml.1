Return-Path: <linux-kernel-owner+w=401wt.eu-S1759708AbYGPWMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708AbYGPWMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 18:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbYGPWMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 18:12:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40823 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbYGPWMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 18:12:07 -0400
Date: Wed, 16 Jul 2008 23:12:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: David Teigland <teigland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dlm: sparse endian annotations
Message-ID: <20080716221201.GM28946@ZenIV.linux.org.uk>
References: <1216239367.28841.22.camel@brick> <20080716213801.GK28946@ZenIV.linux.org.uk> <1216244621.28841.35.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216244621.28841.35.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 02:43:41PM -0700, Harvey Harrison wrote:
> On Wed, 2008-07-16 at 22:38 +0100, Al Viro wrote:
> > On Wed, Jul 16, 2008 at 01:16:07PM -0700, Harvey Harrison wrote:
> > 
> > 
> > NAK on ones below.  You are only hiding the warnings; ...s() is not making
> > it any better.
> > 
> 
> I'd suggest that any use of {endian}s() points to code that should be
> looked at.  But if you'd also rather have the warnings, so be it.

Frankly, I would rather have the rest of byteswaps in dlm eliminated...
