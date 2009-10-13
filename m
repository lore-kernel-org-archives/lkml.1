Return-Path: <linux-kernel-owner+w=401wt.eu-S1759654AbZJMMbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759654AbZJMMbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 08:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759641AbZJMMbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 08:31:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759330AbZJMMbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 08:31:12 -0400
Date: Tue, 13 Oct 2009 09:30:42 -0300
From: Glauber Costa <glommer@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH] fix msr list
Message-ID: <20091013123042.GB8092@mothafucka.localdomain>
References: <1254849890-3916-1-git-send-email-glommer@redhat.com> <20091012175026.GA4768@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012175026.GA4768@amt.cnet>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 02:50:27PM -0300, Marcelo Tosatti wrote:
> On Tue, Oct 06, 2009 at 01:24:50PM -0400, Glauber Costa wrote:
> > For a while now, we are issuing a rdmsr instruction to find out which msrs in our
> > save list are really supported by the underlying machine. However, it fails to account
> > for kvm-specific msrs, such as the pvclock ones.
> > 
> > This patch moves then to the beginning of the list, and skip testing them.
> > 
> > Signed-off-by: Glauber Costa <glommer@redhat.com>
> 
> Applied, thanks.
> 
> But this alone won't fix migration to include the two pvclock MSRs
> right?
Yes, exactly. It will just make userspace see the correct list, but we'd
still have to take action based on it.

