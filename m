Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbYH0PJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbYH0PJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 11:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbYH0PJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 11:09:08 -0400
Received: from smtp.nokia.com ([192.100.122.233]:21549 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbYH0PJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 11:09:06 -0400
Message-ID: <48B56ADA.8010808@yandex.ru>
Date: Wed, 27 Aug 2008 17:55:22 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH 01/59] CRED: Wrap task credential accesses in the IA64
 arch
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk> <20080827134547.19980.38813.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080827134547.19980.38813.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Aug 2008 14:58:32.0727 (UTC) FILETIME=[5FAE4A70:01C90855]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Wrap access to task credentials so that they can be separated more easily from
> the task_struct during the introduction of COW creds.
> 
> Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().
> 
> Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
> sense to use RCU directly rather than a convenient wrapper; these will be
> addressed by later patches.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: James Morris <jmorris@namei.org>
> Acked-by: Serge Hallyn <serue@us.ibm.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: linux-ia64@vger.kernel.org

Fine with me. Do you want us to put this patch to ubifs-2.6.git or you
prefer to make it go together with the rest of the CRED patches?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
