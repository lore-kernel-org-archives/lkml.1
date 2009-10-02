Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbZJBWhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbZJBWhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 18:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127AbZJBWhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 18:37:22 -0400
Received: from 8bytes.org ([88.198.83.132]:36495 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089AbZJBWhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 18:37:19 -0400
Date: Sat, 3 Oct 2009 00:37:22 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: linux-kernel@vger.kernel.org, avi@qumranet.com, avi@redhat.com,
       kvm@vger.kernel.org
Subject: Re: [PATCH][retry 2] Support Pause Filter in AMD processors
Message-ID: <20091002223722.GC23379@8bytes.org>
References: <200910021449.59284.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910021449.59284.mark.langsdorf@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 02:49:59PM -0500, Mark Langsdorf wrote:
> +static int pause_interception(struct vcpu_svm *svm)
> +{
> +	static int pause_count = 0;
> +
> +	kvm_vcpu_on_spin(&(svm->vcpu));
> +printk(KERN_ERR "MJLL pause intercepted %d\n", ++pause_count);

Debugging leftover?

> +	return 1;
> +}
