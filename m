Return-Path: <linux-kernel-owner+w=401wt.eu-S1757754AbZEAWYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbZEAWYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 18:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764381AbZEAWYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 18:24:20 -0400
Received: from mga10.intel.com ([192.55.52.92]:60787 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763911AbZEAWYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 18:24:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,280,1239001200"; 
   d="scan'208";a="453387750"
Message-ID: <49FB7692.2000508@linux.intel.com>
Date: Fri, 01 May 2009 15:24:18 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: "N" symbols and System.map
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

right now, we filter out symbols that nm tag N, meaning "debugging 
symbols", from System.map.  However, at least on x86, the 
linker-generated symbol _end is tagged N, and in fact is the only N in 
the entire image.

Are there other architectures which would suffer if N were included in 
System.map, or would that be a reasonable thing to do?

	-hpa

