Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbXFURH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbXFURH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756153AbXFURHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:07:19 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55195 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756066AbXFURHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:07:18 -0400
Date: Thu, 21 Jun 2007 10:07:12 -0700
From: Paul Jackson <pj@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: vatsa@linux.vnet.ibm.com, clameter@sgi.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, akpm@linux-foundation.org
Subject: Re: cpuset attach_task to touch per-cpu kernel threads?
Message-Id: <20070621100712.52a4784a.pj@sgi.com>
In-Reply-To: <20070621121635.GB19811@elte.hu>
References: <20070621014935.GF10980@linux.vnet.ibm.com>
	<20070621121635.GB19811@elte.hu>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, responding to Srivatsa:
> > Or maybe allow movement if it 
> > doesn't result in changing kernel-threads's cpu affinity.
> 
> yeah, i'd agree ..

Good point.  I'd agree too.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
