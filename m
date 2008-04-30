Return-Path: <linux-kernel-owner+w=401wt.eu-S1760871AbYD3PFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871AbYD3PFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 11:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbYD3PF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 11:05:28 -0400
Received: from smtp-out25.alice.it ([85.33.2.25]:3436 "EHLO
	smtp-out25.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198AbYD3PF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 11:05:27 -0400
X-Greylist: delayed 914 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Apr 2008 11:05:27 EDT
From: Fabio De Francesco <fabiomdf@alice.it>
To: linux-kernel@vger.kernel.org
Subject: [x86_32] With 4GB installed, in which cases low mem total is less than 896MB?
Date: Wed, 30 Apr 2008 17:02:02 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804301702.06019.fabiomdf@alice.it>
X-OriginalArrivalTime: 30 Apr 2008 14:49:14.0953 (UTC) FILETIME=[5C107B90:01C8AAD1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've got a Linux box, Intel Core 2 T7700 with 4GB RAM installed, with vanilla kernel 2.6.24 + TuxOnIce patch-set compiled for x86_32bit (CONFIG_X86_32=y), whose /proc/meminfo shows "LowTotal 794MB".

I've always known that, in this specific platform, Linux permanently maps 896MB as "Low Memory" into its linear address space (as this last value is the one /proc/meminfo shows in the other two x86_32bit computers I own). 

What am I missing?

A further issue is about the "MemTotal" value that only shows more or less 3550MB with HIGHMEM4G selected, and it shows a  more satisfying value of 4050MB with HIGHMEM64G + X86_PAE + RESOURCES_64BIT selected. In both cases LowTotal is always less than 800MB.

Why is it needed to activate the PAE mechanism in order to see and use the whole 4GB memory? Is it what it is expected to be done?

Thanks in advance to anyone who will reply.

Regards,

fabio de francesco
metanix.org
