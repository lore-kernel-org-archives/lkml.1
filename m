Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbZCGLGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbZCGLGw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 06:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbZCGLGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 06:06:43 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:43219 "EHLO pardus.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751548AbZCGLGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 06:06:42 -0500
Message-ID: <49B254C6.8010507@pardus.org.tr>
Date: Sat, 07 Mar 2009 13:04:38 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC] A simple way to determine if the kernel needs HIGHMEM64G to
 be able to use all the installed memory
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When the installed memory size is >= 4GB, kernel drops some messages like

Warning only 4GB of memory will be used
You have to enable HIGHMEM64G.

I checked that the message comes from arch/x86/init_32.c after checking
max_pfn.

I'm quite dumb about the internal structures of the kernel but, wouldn't it
be possible to create a simple read-only sysfs object like kexec_loaded
that will contain "1" when the kernel needs HIGHMEM64G to see all of the memory
and "0" when it doesn't?

I think that it would be a nice facility for distribution kernels to detect
the need for a PAE enabled 32-bit kernel by just reading some /sys/.. entry.

Thanks,

-- 

Ozan Çağlayan
<ozan_at_pardus.org.tr>
