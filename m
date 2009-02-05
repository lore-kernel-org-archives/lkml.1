Return-Path: <linux-kernel-owner+w=401wt.eu-S1756935AbZBESxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbZBESxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbZBESxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:53:10 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:33155 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752326AbZBESxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:53:09 -0500
Subject: Re: [PATCH 1/2] show hypervisor information on cpuinfo
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Glauber Costa <glommer@redhat.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>, "avi@redhat.com" <avi@redhat.com>,
       Glauber Costa <gcosta@redhat.com>
In-Reply-To: <1233859341-10419-2-git-send-email-glommer@redhat.com>
References: <1233859341-10419-1-git-send-email-glommer@redhat.com>
	 <1233859341-10419-2-git-send-email-glommer@redhat.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 05 Feb 2009 10:53:07 -0800
Message-Id: <1233859987.29693.9.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am all for it.

Just one nit, below.

>  
> +char * __cpuinit hypervisor_str(struct cpuinfo_x86 *c)
> +{
> +	if (c->x86_hyper_vendor == X86_HYPER_VENDOR_VMWARE)
> +		return "VMWare";

Better to have "VMware" string instead.

Thanks,
Alok

