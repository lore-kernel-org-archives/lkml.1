Return-Path: <linux-kernel-owner+w=401wt.eu-S1752582AbXEXTYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbXEXTYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 15:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbXEXTYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 15:24:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:32497 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbXEXTYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 15:24:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=UqpYtJhmgkfZZLdyFLHixp1jllB/ft1XqQjut0LbLiG4f5DCwVFXwcAa7L2SCbzPKqsBo3pCb6LKe5IPm5PBn3rPNkaRHDYlbFc6SWTyYl8U1tYV5hneGu8T/pkS4rVDEHNLtK37U7GTWiCvWhVnhkNu9i81N+SCiq5rFoDitJg=
Date: Thu, 24 May 2007 23:23:21 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Jan Kara <jack@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Fix possible UDF data corruption
Message-ID: <20070524192321.GD20500@cvg>
References: <20070524165935.GB19709@duck.suse.cz> <20070524172017.GA19852@cvg> <20070524113550.d09dbf9e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524113550.d09dbf9e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Andrew Morton - Thu, May 24, 2007 at 11:35:50AM -0700]
| On Thu, 24 May 2007 21:20:17 +0400
| Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > [Jan Kara - Thu, May 24, 2007 at 06:59:35PM +0200]
| > |   Hi Andrew,
| > | 
| > |   attached patch fixes possible data corruption in UDF - this bug was actually
| > | introduced by one of my fixes :-( and should (if possible) go to Linus before
| > | 2.6.22 is out (that's why I'm diffing against Linus's tree and not the
| > | latest changes in -mm tree)... Thanks.
| > | 
| > | 								Honza
| > | 
| > | -- 
| > | Jan Kara <jack@suse.cz>
| > | SuSE CR Labs
| > 
| > Jan should I wait until Andrew has your patches included and
| > only then (having taken into account your patches) produce my
| > conversion?
| > 
| 
| yes please - bugfixes come first.
| 

Andrew, so could I assume that these patches are in your -mm tree
to be able to work on UDF style conversion?

		Cyrill

