Return-Path: <linux-kernel-owner+w=401wt.eu-S932762AbZJLRvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762AbZJLRvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbZJLRvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:51:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbZJLRvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:51:05 -0400
Date: Mon, 12 Oct 2009 14:50:27 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH] fix msr list
Message-ID: <20091012175026.GA4768@amt.cnet>
References: <1254849890-3916-1-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254849890-3916-1-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 01:24:50PM -0400, Glauber Costa wrote:
> For a while now, we are issuing a rdmsr instruction to find out which msrs in our
> save list are really supported by the underlying machine. However, it fails to account
> for kvm-specific msrs, such as the pvclock ones.
> 
> This patch moves then to the beginning of the list, and skip testing them.
> 
> Signed-off-by: Glauber Costa <glommer@redhat.com>

Applied, thanks.

But this alone won't fix migration to include the two pvclock MSRs
right?

