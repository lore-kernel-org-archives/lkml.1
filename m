Return-Path: <linux-kernel-owner+w=401wt.eu-S932973AbXGQP0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973AbXGQP0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbXGQP0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:26:16 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:17690 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbXGQP0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:26:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAGh8nEarR7PE/2dsb2JhbAA
X-IronPort-AV: i="4.16,546,1175497200"; 
   d="scan'208"; a="183577052:sNHT24203826"
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@osdl.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH] ivtv: don't recompile needlessly
X-Message-Flag: Warning: May contain useful information
References: <20070717114741.GC25083@localhost.sw.ru>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 17 Jul 2007 08:26:12 -0700
In-Reply-To: <20070717114741.GC25083@localhost.sw.ru> (Alexey Dobriyan's message of "Tue, 17 Jul 2007 15:47:41 +0400")
Message-ID: <adabqebt5kb.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Jul 2007 15:26:13.0068 (UTC) FILETIME=[CF31F8C0:01C7C886]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 >  	printk(KERN_INFO "ivtv:  ==================== START INIT IVTV ====================\n");

This also looks pretty useless and way too garish given the fact that
it contains no information not already given by the next line printed.
