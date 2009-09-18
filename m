Return-Path: <linux-kernel-owner+w=401wt.eu-S1754318AbZIRGxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbZIRGxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 02:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbZIRGxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 02:53:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbZIRGxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 02:53:48 -0400
Date: Fri, 18 Sep 2009 03:53:14 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH 0/5] Another set of Nested SVM fixes and cleanups
Message-ID: <20090918065314.GA383@amt.cnet>
References: <1253107459-8967-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253107459-8967-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 03:24:14PM +0200, Joerg Roedel wrote:
> Hi,
> 
> this series of patches contain another set of cleanups and an important fix to
> the Nested SVM code. These patches make the TSC handling code for SVM aware of
> a nested guest. This fixes the TSC running backwards on guest and nested guest.
> The backwards running TSC resulted in stalled guests when kvm-clock was
> enabled. Please consider to apply.

Applied, thanks (added Cc: stable to 3 and 4).

