Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbZLBRln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbZLBRln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 12:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbZLBRlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 12:41:42 -0500
Received: from fifo99.com ([67.223.236.141]:45591 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbZLBRll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 12:41:41 -0500
Subject: Re: [v10 PATCH 9/9]: POWER: Enable default_idle when power_save=off
From: Daniel Walker <dwalker@fifo99.com>
To: arun@linux.vnet.ibm.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-arch@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <20091202100346.GJ27251@linux.vnet.ibm.com>
References: <20091202095427.GA27251@linux.vnet.ibm.com>
	 <20091202100346.GJ27251@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Dec 2009 09:41:38 -0800
Message-ID: <1259775698.25622.2.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 15:33 +0530, Arun R Bharadwaj wrote:
> +int boot_option_idle_override = 0;
> + 

Doesn't need to be set to zero AFAIK, since we do a mass initialization
to zero during boot up. Did you notice some type of failure when you
didn't initialize that to zero?

(checkpatch output below..)
--

ERROR: do not initialise externals to 0 or NULL
#97: FILE: arch/powerpc/kernel/idle.c:43:
+int boot_option_idle_override = 0;

total: 1 errors, 0 warnings, 0 checks, 31 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.



