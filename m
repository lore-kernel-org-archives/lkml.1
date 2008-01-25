Return-Path: <linux-kernel-owner+w=401wt.eu-S1759566AbYAYSFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566AbYAYSFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 13:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759305AbYAYSEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 13:04:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:50048 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758558AbYAYSEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 13:04:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,251,1199692800"; 
   d="scan'208";a="508190427"
Date: Fri, 25 Jan 2008 10:04:06 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Roland McGrath <roland@redhat.com>
Cc: mingo@elte.hu, tglx@linutronix.de,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm] x86: i387 fpregs_set convert_to_fxsr
Message-ID: <20080125180406.GB5342@linux-os.sc.intel.com>
References: <20080125014059.GA5342@linux-os.sc.intel.com> <20080125015933.587DF26F9FD@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125015933.587DF26F9FD@magilla.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 05:59:33PM -0800, Roland McGrath wrote:
> +	if (pos > 0 || count < sizeof(env))
> +		convert_from_fxsr(&env, target);

Well, is the generic regset code enforce the need for this now? Can we
disallow the usage cases where the user passes smaller target buffer
size or requests data from in between. We were disallowing such usage
scenarios before, isn't it?

thanks,
suresh
