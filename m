Return-Path: <linux-kernel-owner+w=401wt.eu-S1759262AbYA1O7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbYA1O7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 09:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbYA1O7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 09:59:08 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:1284 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbYA1O7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 09:59:07 -0500
Date: Mon, 28 Jan 2008 14:59:11 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Andi Kleen <ak@suse.de>
Cc: rdunlap@xenotime.net, jschopp@austin.ibm.com, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Deprecate checkpatch.pl --file mode; add warning; add --file-force
Message-ID: <20080128145911.GJ12910@shadowen.org>
References: <20080116222121.GA7185@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116222121.GA7185@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 11:21:21PM +0100, Andi Kleen wrote:

> Deprecate checkpatch.pl --file mode; add warning; add --file-force
> 
> As discussed on linux-kernel checkpatch.pl only patches for whole
> files have a significant cost. Better such changes should be only
> done together with other changes. Add a explicit warning about
> this; deprecate --file and add a --file-force instead.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>

Cirtainly I can see why we want this
warning out there and very much in the submitters face, it just feels a
little heavy handed to make them change option to get the result.

Would not just always appending this message in --file mode always be
just as effective?  Perhaps suppressing it with -q, or with some new "i
know what I am doing" option?

-apw
