Return-Path: <linux-kernel-owner+w=401wt.eu-S1759732AbZDHOd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732AbZDHOd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbZDHOdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:33:13 -0400
Received: from rtr.ca ([76.10.145.34]:51594 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbZDHOdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:33:11 -0400
Message-ID: <49DCB5A5.7040100@rtr.ca>
Date: Wed, 08 Apr 2009 10:33:09 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com, David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [PATCH 4/5] ide: Add support for TRIM
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <1238683047-13588-2-git-send-email-willy@linux.intel.com> <1238683047-13588-3-git-send-email-willy@linux.intel.com> <1238683047-13588-4-git-send-email-willy@linux.intel.com>
In-Reply-To: <1238683047-13588-4-git-send-email-willy@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> From: David Woodhouse <David.Woodhouse@intel.com>
> 
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> [modified to reduce amount of special casing needed for discard]
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
..
> +	task->tf.command = ATA_CMD_DSM;
> +	task->tf.feature = ATA_DSM_TRIM;
> +	task->tf.hob_feature = 0x00;
> +	task->tf.nsect = size / 512;
> +	task->tf.hob_nsect = (size / 512) >> 8;
..

Matthew (or others),

Could you perhaps explain what the purpose of the data portion
of this command is for?  The draft ATA spec I have here has mangled
text in the description -- like it's missing a crucial sentence there.

So it's not obvious exactly why this command even needs data to
be transfered.

Thanks
