Return-Path: <linux-kernel-owner+w=401wt.eu-S1760818AbYFLWmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760818AbYFLWmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759067AbYFLWma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:42:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44071 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758418AbYFLWm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:42:29 -0400
Message-ID: <4851A639.6040405@zytor.com>
Date: Thu, 12 Jun 2008 15:42:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Add config option to setup early serial console
References: <20080612223802.528617000@polaris-admin.engr.sgi.com> <20080612223802.673729000@polaris-admin.engr.sgi.com>
In-Reply-To: <20080612223802.673729000@polaris-admin.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
>  * Add config option EARLY_SERIAL_CONSOLE to enable early
>    printk's to be directed to the serial console.
> 
> Based on linux-next
> 
> Signed-off-by: Mike Travis <travis@sgi.com>

Is there any reason this can't be done dynamically, via a command-line 
option instead?

We can get to the command line extremely early if need be.

	-hpa
