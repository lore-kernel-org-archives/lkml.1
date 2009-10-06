Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbZJFAJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbZJFAJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 20:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbZJFAJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 20:09:31 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59218 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995AbZJFAJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 20:09:30 -0400
Date: Mon, 5 Oct 2009 17:09:11 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] signals: SEND_SIG_NOINFO should be considered as
	SI_FROMUSER()
Message-ID: <20091006000911.GB4390@us.ibm.com>
References: <4AC608BE.9020805@fr.ibm.com> <20091003171029.GA30442@us.ibm.com> <20091004021844.GA21006@redhat.com> <20091004021918.GB21006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091004021918.GB21006@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov [oleg@redhat.com] wrote:
| No changes in compiled code. The patch adds the new helper, si_fromuser()
| and changes check_kill_permission() to use this helper.
| 
| The real effect of this patch is that from now we "officially" consider
| SEND_SIG_NOINFO signal as "from user-space" signals. This is already true
| if we look at the code which uses SEND_SIG_NOINFO, except __send_signal()
| has another opinion - see the next patch.
| 
| The naming of these special SEND_SIG_XXX siginfo's is really bad imho.
| >From __send_signal()'s pov they mean
| 
| 	SEND_SIG_NOINFO		from user
| 	SEND_SIG_PRIV		from kernel
| 	SEND_SIG_FORCED		no info
| 
| Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Renaming the special siginfo cases be done independently.

Reviewed-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
