Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab0BPJBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 04:01:06 -0500
Received: from poutre.nerim.net ([62.4.16.124]:49217 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492Ab0BPJBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 04:01:04 -0500
Date: Tue, 16 Feb 2010 10:01:00 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20100216100100.55f5922f@hyperion.delvare>
In-Reply-To: <20100216173926.b7a4d25c.sfr@canb.auug.org.au>
References: <20100216173926.b7a4d25c.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, 16 Feb 2010 17:39:26 +1100, Stephen Rothwell wrote:
> After merging the driver-core tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/i2c/i2c-smbus.c:58: error: 'struct device' has no member named 'sem'
> drivers/i2c/i2c-smbus.c:66: error: 'struct device' has no member named 'sem'
> 
> Caused by commit 0819a881db29059d113fc5f019f7c489dea5937d from the
> driver-core tree interacting with commit
> 38f1e8aedf0a238d56fbcd3660fc140b50dbc89a ("i2c: Add SMBus alert support")
> from the i2c tree.
> 
> I have applied the following patch for today and will use it as a merge
> fixup for the driver-core tree while necessary.

Thanks for the heads up and the fix. Greg, is there an API I am
supposed to use instead of accessing the device's semaphore/mutex
directly?

-- 
Jean Delvare
