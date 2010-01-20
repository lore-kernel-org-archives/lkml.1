Return-Path: <linux-kernel-owner+w=401wt.eu-S1752867Ab0ATJ6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab0ATJ6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 04:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462Ab0ATJ6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 04:58:20 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48152 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab0ATJ6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 04:58:18 -0500
Date: Wed, 20 Jan 2010 09:57:57 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tomasz Fujak <t.fujak@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       jpihet@mvista.com, peterz@infradead.org, p.osciak@samsung.com,
       jamie.iles@picochip.com, will.deacon@arm.com, kyungmin.park@samsung.com,
       mingo@elte.hu, m.szyprowski@samsung.com
Subject: Re: [PATCH/RFC v1 0/2] Human readable performance event
	description in sysfs
Message-ID: <20100120095757.GA20302@n2100.arm.linux.org.uk>
References: <1263978706-15499-1-git-send-email-t.fujak@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263978706-15499-1-git-send-email-t.fujak@samsung.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 10:11:44AM +0100, Tomasz Fujak wrote:
> The following patches provide a sysfs entry with hardware event human
> readable description in the form of "0x%llx\t%lld-%lld\t%s\t%s" %
> (event_value, minval, maxval, name, description)

I think your patch is in violation of this from
Documentation/filesystems/sysfs.txt:

Attributes
~~~~~~~~~
...
Attributes should be ASCII text files, preferably with only one value
per file. It is noted that it may not be efficient to contain only one
value per file, so it is socially acceptable to express an array of
values of the same type.

Mixing types, expressing multiple lines of data, and doing fancy
formatting of data is heavily frowned upon. Doing these things may get
you publically humiliated and your code rewritten without notice.

