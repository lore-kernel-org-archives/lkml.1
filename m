Return-Path: <linux-kernel-owner+w=401wt.eu-S1946311AbXEAFCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946311AbXEAFCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 01:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423791AbXEAFCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 01:02:36 -0400
Received: from [212.12.190.247] ([212.12.190.247]:32867 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423789AbXEAFCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 01:02:35 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_HIGHMEM4G and 1GB RAM
Date: Tue, 1 May 2007 08:06:27 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705010806.27668.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>> The CONFIG_VMSPLIT config options were merged for such cases.
>> It should be able to split on any 4MB-aligned boundary in
>> CONFIG_HIGHMEM4G. CONFIG_VMSPLIT_3G_OPT appears to do something of
>> this sort to use an entire 1GB RAM with minimal user address space
>> reduction.
>> This is an ELF ABI violation but the number of major applications
>> that break is apparently low.

On Mon, Apr 30, 2007 at 11:18:28PM +0100, Matt Keenan wrote:
> wine and some java implementations being two of the big caveats.

If this is really true, then I think it critical to be mentioned in the 
Kconfig help text.


Thanks!

--
Al

