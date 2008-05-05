Return-Path: <linux-kernel-owner+w=401wt.eu-S1760187AbYEET5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187AbYEET5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbYEET5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:57:40 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:54142 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbYEET5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:57:40 -0400
Date: Mon, 5 May 2008 21:58:15 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, ltp-list@lists.sourceforge.net,
       ltp-coverage@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 3/6] kbuild: convert include and source paths
Message-ID: <20080505195815.GD8868@uranus.ravnborg.org>
References: <481F26AA.4050701@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481F26AA.4050701@de.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 05:24:26PM +0200, Peter Oberparleiter wrote:
> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> 
> Modify kbuild to convert relative include and source paths to absolute
> form. Also change the module versioning mechanism to alter object file
> names only after compiling.
> 
> Required by the gcov profiling infrastructure: source paths are
> referenced by the compiled object files. Using relative paths or
> object file names which are different from the source name would
> prevent the gcov tool from finding the corresponding source files.

For the relative path issue do you really fix this at the right place?
I would say that teaching gcov tool from where to look would be better.

> Also change the module versioning mechanism to alter object file
> names only after compiling.
Can I get this as a separate patch please.
It may be general useful and makes sense to look at alone.

	Sam
