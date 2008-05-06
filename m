Return-Path: <linux-kernel-owner+w=401wt.eu-S1762673AbYEFOjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762673AbYEFOjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 10:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757317AbYEFOj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 10:39:27 -0400
Received: from smtpdr.citrix.com ([68.156.138.135]:58844 "EHLO
	SMTPDR.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761452AbYEFOj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 10:39:26 -0400
X-Greylist: delayed 630 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 May 2008 10:39:26 EDT
X-IronPort-AV: E=Sophos;i="4.27,443,1204520400"; 
   d="scan'208";a="97316"
Message-ID: <48206A97.6070408@citrix.com>
Date: Tue, 06 May 2008 15:26:31 +0100
From: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] make mm/memory_hotplug.c:online_page() static
References: <20080505182344.GI17139@cs181133002.pp.htv.fi>
In-Reply-To: <20080505182344.GI17139@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 May 2008 14:28:48.0799 (UTC) FILETIME=[7FB2BAF0:01C8AF85]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Now that it's in the same file as it's caller online_page() can become 
> static.
>   

I have a patch to call it from elsewhere, so I'd like to keep it as a 
kernel-internal API for now.

    J

