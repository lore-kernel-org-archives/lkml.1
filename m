Return-Path: <linux-kernel-owner+w=401wt.eu-S1758885AbZLIX7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbZLIX7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 18:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758869AbZLIX7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 18:59:14 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:26800 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758862AbZLIX7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 18:59:12 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.47,371,1257120000"; 
   d="scan'208";a="447352004"
From: Roland Dreier <rdreier@cisco.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, mingo@elte.hu, nhorman@tuxdriver.com,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, torvalds@linux-foundation.org,
       oleg@redhat.com, James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 23/27] misc: use helpers for rlimits
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
	<1259363167-9347-23-git-send-email-jslaby@suse.cz>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 09 Dec 2009 15:59:18 -0800
In-Reply-To: <1259363167-9347-23-git-send-email-jslaby@suse.cz> (Jiri Slaby's
	message of "Sat, 28 Nov 2009 00:06:03 +0100")
Message-ID: <adapr6nog15.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Dec 2009 23:59:18.0354 (UTC) FILETIME=[9E84D320:01CA792B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure it matters at this part, but for the drivers/infiniband part,
you can add:

Acked-by: Roland Dreier <rolandd@cisco.com>

wrapping all the current->signal->rlim[] stuff in a helper function
looks like a nice cleanup independent of the writable limit stuff.

 - R.
