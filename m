Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbYC1CIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbYC1CIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 22:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbYC1CHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 22:07:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:65353 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421AbYC1CHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 22:07:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,566,1199692800"; 
   d="scan'208";a="265457201"
Subject: Re: [PATCH -mm 2/4] x86_64 boot: Add linked list of struct
	setup_data
From: "Huang, Ying" <ying.huang@intel.com>
To: Paul Jackson <pj@sgi.com>
Cc: hpa@zytor.com, andi@firstfloor.org, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080327063307.ac323913.pj@sgi.com>
References: <1206601748.3067.22.camel@caritas-dev.intel.com>
	 <20080327063307.ac323913.pj@sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 28 Mar 2008 10:09:41 +0800
Message-Id: <1206670181.13404.7.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 28 Mar 2008 02:06:39.0380 (UTC) FILETIME=[5BFC5D40:01C89078]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-27 at 06:33 -0500, Paul Jackson wrote:
> Huang wrote:
> +/* setup data types */
> +#define SETUP_NONE			0
> +
> +/* extensible setup data list node */
> +struct setup_data {
> +	u64 next;
> +	u32 type;
> +	u32 len;
> +	u8 data[0];
> +};
> 
> 
> I don't understand what purpose the 'type' field serves.

The setup_data will not only be used for E820 extension. So a type field
is used to distinguish various setup_data.

Best Regards,
Huang Ying
