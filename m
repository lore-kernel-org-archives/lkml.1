Return-Path: <linux-kernel-owner+w=401wt.eu-S1764925AbYBMShi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764925AbYBMShi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 13:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbYBMSha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 13:37:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53784 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbYBMSh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 13:37:29 -0500
Message-ID: <47B338E2.20409@zytor.com>
Date: Wed, 13 Feb 2008 10:37:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: "avoid overflows in kernel/time" breakes my ondemand scheduler
References: <200802130938.50749.borntraeger@de.ibm.com>
In-Reply-To: <200802130938.50749.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> Hello H. Peter,
> 
> the patch "avoid overflows in kernel/time" makes the ondemand cpufreq 
> scheduler unusable. It looks like the cpufreq scheduler takes minutes to 
> react on load changes.
> 
> I looked at the patch but did not found an obvious problem. Reverting this 
> patch seems to fix the problem.
> 
> Do you have any ideas?
> 
> Christian 

Yes, a patch has already been sent upstream.

	-hpa
