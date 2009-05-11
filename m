Return-Path: <linux-kernel-owner+w=401wt.eu-S1757610AbZEKJIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbZEKJIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757448AbZEKJHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:07:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:36638 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757429AbZEKJHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:07:32 -0400
Subject: Re: [PATCH -v3] KVM: MCE: Add MCE support to KVM
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1242031695.8213.17.camel@yhuang-dev.sh.intel.com>
References: <1242031695.8213.17.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain
Date: Mon, 11 May 2009 14:35:01 +0530
Message-Id: <1242032701.3114.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-11 at 16:48 +0800, Huang Ying wrote:
> +int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
> +{
> +	u64 data;
> +
> +	switch (msr) {
> +	case 0xc0010010: /* SYSCFG */
> +	case 0xc0010015: /* HWCR */

You can replace this with :

+	case MSR_K8_SYSCFG:
+	case MSR_K8_HWCR:

--
JSR


