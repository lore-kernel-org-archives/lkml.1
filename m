Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbZI3Ni6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbZI3Ni6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 09:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbZI3Ni5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 09:38:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbZI3Ni4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 09:38:56 -0400
Date: Wed, 30 Sep 2009 10:35:42 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH v4: kvm 4/4] Fix hotplug of CPUs for KVM.
Message-ID: <20090930133542.GA15312@amt.cnet>
References: <4AC1C59F.6010703@redhat.com> <1254260317-3490-1-git-send-email-zamsden@redhat.com> <1254260317-3490-2-git-send-email-zamsden@redhat.com> <1254260317-3490-3-git-send-email-zamsden@redhat.com> <1254260317-3490-4-git-send-email-zamsden@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254260317-3490-4-git-send-email-zamsden@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 11:38:37AM -1000, Zachary Amsden wrote:
> Both VMX and SVM require per-cpu memory allocation, which is done at module
> init time, for only online cpus.
> 
> Backend was not allocating enough structure for all possible CPUs, so
> new CPUs coming online could not be hardware enabled.
> 
> Signed-off-by: Zachary Amsden <zamsden@redhat.com>

Applied all, thanks.

