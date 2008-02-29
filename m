Return-Path: <linux-kernel-owner+w=401wt.eu-S1760321AbYB2Onh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760321AbYB2Onh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 09:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbYB2Ona
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 09:43:30 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:2826 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbYB2On3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 09:43:29 -0500
Date: Fri, 29 Feb 2008 14:44:37 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dirk Eibach <eibach@gdsys.de>, linux-kernel@vger.kernel.org,
       greg@kroah.com
Subject: Re: [PATCH] usb: add sysfs configuration interface for CP2101
Message-ID: <20080229144437.GD28849@shadowen.org>
References: <47C7CA1A.3080001@gdsys.de> <20080229020245.61f1f8f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229020245.61f1f8f4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 02:02:45AM -0800, Andrew Morton wrote:
> On Fri, 29 Feb 2008 10:02:18 +0100 Dirk Eibach <eibach@gdsys.de> wrote:

> We have a new strict_strtoul() (and related functions) which will perform
> proper checking for a valid number.  Please use that interface.
> 
> Andy, this is going to happen so much that a "should you have used
> strict_strtoul?" warning in checkpatch would reduce my email output.

Sure, will add something.  I wonder if this new interface is documented.

I note that this interface is new in -mm at this time.  So that brings
up an interesting question as to how one would integrate this check with
checkpatch.  As checking patches for mainline, this would be an
incorrect check until that patch merges.  I guess the right thing to do
is provide a separate patch for checkpatch which adds this check which
should sit with the patch in your tree which adds the functionality.

Make sense?

-apw
