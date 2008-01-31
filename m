Return-Path: <linux-kernel-owner+w=401wt.eu-S1764948AbYAaJ0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764948AbYAaJ0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 04:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbYAaJ0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 04:26:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:51410 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbYAaJ0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 04:26:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ChPvBuUjUlT+zbLZUHREcjsl6yCUy3iC428RPtxYEp8Am4elV2N8MNB/odpeOMu+D8A8feMyBQpr9CZpp189DyKRGtA2WD1hN/JhbOkUpAvWw6JPcXuzt7XlDr/kINDmDLnXPbu7T1YDHK+KGU1ly9V5EN+l2gMTie0AY2g0M1k=
Message-ID: <47A19439.90409@gmail.com>
Date: Thu, 31 Jan 2008 10:26:17 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       xiyou.wangcong@gmail.com
Subject: Re: [PATCH 2/2] Char: applicom, use pci_match_id
References: <20080128054917.GA10504@hacking>	<1201691595-11448-2-git-send-email-jirislaby@gmail.com> <20080130151022.c52ad664.akpm@linux-foundation.org>
In-Reply-To: <20080130151022.c52ad664.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2008 12:10 AM, Andrew Morton wrote:
> On Wed, 30 Jan 2008 12:13:15 +0100
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> +		if (!pci_match_id(applicom_pci_tbl, dev));
>>  			continue;
> 
> 
> The patch was carelessly prepared, was not runtine-tested and was not
> passed through checkpatch, which detects this error.  Please fix these
> things, permanently.

Yes, you're right, I definitely need to change my workflow, this needn't happen.
