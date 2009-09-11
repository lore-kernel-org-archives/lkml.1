Return-Path: <linux-kernel-owner+w=401wt.eu-S1751890AbZIKA5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbZIKA5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbZIKA5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:57:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39586 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbZIKA5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:57:42 -0400
Message-ID: <4AA9A031.5000602@zytor.com>
Date: Thu, 10 Sep 2009 17:56:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: David Daney <ddaney@caviumnetworks.com>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 02/10] x86: Convert BUG() to use unreachable()
References: <4AA991C1.1050800@caviumnetworks.com> <1252627011-2933-2-git-send-email-ddaney@caviumnetworks.com>
In-Reply-To: <1252627011-2933-2-git-send-email-ddaney@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2009 04:56 PM, David Daney wrote:
> Use the new unreachable() macro instead of for(;;);.  When
> allyesconfig is built with a GCC-4.5 snapshot on i686 the size of the
> text segment is reduced by 3987 bytes (from 6827019 to 6823032).
> 
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: x86@kernel.org

Acked-by: H. Peter Anvin <hpa@zytor.com>

... although of course this clashes with Roland McGrath's patchset for
the same thing which I applied earlier.  I have to say I like
unreachable() in lower case better though...

	-hpa
