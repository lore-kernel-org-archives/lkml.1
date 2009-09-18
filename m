Return-Path: <linux-kernel-owner+w=401wt.eu-S1758465AbZIRSO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465AbZIRSO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 14:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757681AbZIRSO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 14:14:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48306 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615AbZIRSOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 14:14:25 -0400
Message-ID: <4AB3CDEC.5050902@zytor.com>
Date: Fri, 18 Sep 2009 11:14:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] core, x86: Add user return notifiers
References: <1253105134-8862-1-git-send-email-avi@redhat.com> <1253105134-8862-2-git-send-email-avi@redhat.com>
In-Reply-To: <1253105134-8862-2-git-send-email-avi@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2009 05:45 AM, Avi Kivity wrote:
> Add a general per-cpu notifier that is called whenever the kernel is
> about to return to userspace.  The notifier uses a thread_info flag
> and existing checks, so there is no impact on user return or context
> switch fast paths.
> 
> Signed-off-by: Avi Kivity <avi@redhat.com>

The concept of this patch looks entirely sane, as does the code,
*except* for:

+#include <linux/user-return-notifier.h>

... missing header file, and ...

+obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o

... missing source file.

Could you fix the patch, please?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

