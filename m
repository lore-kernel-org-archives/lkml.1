Return-Path: <linux-kernel-owner+w=401wt.eu-S1759466AbZKFQop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466AbZKFQop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 11:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759419AbZKFQoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 11:44:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42658 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758611AbZKFQoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 11:44:44 -0500
Message-ID: <4AF4526B.4060101@zytor.com>
Date: Fri, 06 Nov 2009 08:44:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Matteo Croce <technoboy85@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com> 	<20091003072127.GC21407@elte.hu> <40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com>
In-Reply-To: <40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2009 06:59 AM, Matteo Croce wrote:
> indeed it has MMX, MMXEXT and CMOV, just lacks the long NOP instruction (NOPL).

MMX and MMXEXT are hardly hallmarks of i686, which leaves only cmov.
I'm somewhat wondering about the general value of this patch; is i686
code really that much faster on Geode that it's worth it?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

