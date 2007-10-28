Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbXJ1VRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbXJ1VRQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 17:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbXJ1VRC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 17:17:02 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53267 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbXJ1VRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 17:17:01 -0400
Message-ID: <4724FC38.30909@linux.vnet.ibm.com>
Date: Mon, 29 Oct 2007 02:46:40 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Marcelo Tosatti <marcelo@kvack.org>, linux-kernel@vger.kernel.org,
       drepper@redhat.com, riel@redhat.com, Martin Bligh <mbligh@mbligh.org>,
       linux-mm@kvack.org
Subject: Re: OOM notifications
References: <20071018201531.GA5938@dmt> <20071026140201.ae52757c.akpm@linux-foundation.org>
In-Reply-To: <20071026140201.ae52757c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> It get more complicated with NUMA memory nodes and cgroup memory
> controllers.
> 

At OLS this year, users wanted user space notification of OOM
for cgroup memory controller. When a group is about to OOM,
a notification can help an external application re-adjust
memory limits across the system.

Keeping some memory reserved for handling OOM, this scheme could
be extended to handle global OOM conditions as well.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
