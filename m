Return-Path: <linux-kernel-owner+w=401wt.eu-S965744AbXCVFhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965744AbXCVFhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 01:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965755AbXCVFhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 01:37:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965744AbXCVFha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 01:37:30 -0400
Date: Thu, 22 Mar 2007 01:37:14 -0400
From: Dave Jones <davej@redhat.com>
To: Keith Owens <kaos@ocs.com.au>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, sam@ravnborg.org
Subject: Re: $CHECK can't be overridden
Message-ID: <20070322053714.GE17159@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Keith Owens <kaos@ocs.com.au>,
	Linux Kernel <linux-kernel@vger.kernel.org>, sam@ravnborg.org
References: <20070322051525.GD17159@redhat.com> <12464.1174541199@kao2.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12464.1174541199@kao2.melbourne.sgi.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 04:26:39PM +1100, Keith Owens wrote:
 > Dave Jones (on Thu, 22 Mar 2007 01:15:25 -0400) wrote:
 > >make help implies that supplying $CHECK on the command line
 > >should override sparse as the checker used when building with C=1
 > >Yet, this doesn't seem to be the case.
 > >
 > >This would be useful for cases where for eg, sparse isn't in
 > >the $PATH, allowing an explicit path to the executable to be
 > >passed in automated build environments.
 > 
 > Works for me.
 > 
 > # make C=1 CHECK=foo

Ah, my bad. I was thinking it was an environment var rather
than a makefile var.  I was using 'CHECK=foo make bzImage C=1'

Thanks,

	Dave

-- 
http://www.codemonkey.org.uk
