Return-Path: <linux-kernel-owner+w=401wt.eu-S1752684AbXEXTu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbXEXTu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 15:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbXEXTuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 15:50:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:62340 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbXEXTuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 15:50:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=IlBEulCf7Dm/SnZLMzI4xqJwdhz4m64P0W2Nk1JjQi0pQpHopHQC2zgIRfCI5VI9jxPYiC+d+jhCcLmEYVH1ipujQ2mUZMd/riuua0vkgCgxV6lHjesY6lv/lemOh/lidbqZNOs/nl08hX2o4m54KxbNoVYWtrvvfl5ahuBAw+o=
Date: Thu, 24 May 2007 23:49:19 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Jan Kara <jack@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Fix possible UDF data corruption
Message-ID: <20070524194919.GA8370@cvg>
References: <20070524165935.GB19709@duck.suse.cz> <20070524172017.GA19852@cvg> <20070524113550.d09dbf9e.akpm@linux-foundation.org> <20070524192321.GD20500@cvg> <20070524123621.4327aca9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524123621.4327aca9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Andrew Morton - Thu, May 24, 2007 at 12:36:21PM -0700]
| On Thu, 24 May 2007 23:23:21 +0400
| Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > [Andrew Morton - Thu, May 24, 2007 at 11:35:50AM -0700]
| > | On Thu, 24 May 2007 21:20:17 +0400
| > | Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > | 
| > | > [Jan Kara - Thu, May 24, 2007 at 06:59:35PM +0200]
| > | > |   Hi Andrew,
| > | > | 
| > | > |   attached patch fixes possible data corruption in UDF - this bug was actually
| > | > | introduced by one of my fixes :-( and should (if possible) go to Linus before
| > | > | 2.6.22 is out (that's why I'm diffing against Linus's tree and not the
| > | > | latest changes in -mm tree)... Thanks.
| > | > | 
| > | > | 								Honza
| > | > | 
| > | > | -- 
| > | > | Jan Kara <jack@suse.cz>
| > | > | SuSE CR Labs
| > | > 
| > | > Jan should I wait until Andrew has your patches included and
| > | > only then (having taken into account your patches) produce my
| > | > conversion?
| > | > 
| > | 
| > | yes please - bugfixes come first.
| > | 
| > 
| > Andrew, so could I assume that these patches are in your -mm tree
| > to be able to work on UDF style conversion?
| > 
| 
| Sure.  If something breaks, I'll fix it up.
| 
| If you take the two-patch approach (first patch is Lindent, second patch is
| post-Lindent fixups) then it becomes easy at this end: the first patch is
| the big one and if it breaks, I just re-run Lindent and regenerate it.
| 

OK

		Cyrill

