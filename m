Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbYCKCH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbYCKCH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 22:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbYCKCHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 22:07:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbYCKCHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 22:07:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] signals: fold complete_signal() into send_signal/do_send_sigqueue
In-Reply-To: Oleg Nesterov's message of  Saturday, 8 March 2008 18:10:24 +0300 <20080308151024.GA25188@tv-sign.ru>
References: <20080308151024.GA25188@tv-sign.ru>
X-Shopping-List: (1) Incredulous raucous rectums
   (2) Pharmaceutical argumentation protrusions
   (3) Nervous confusion swindlers
   (4) Energetic assumptions
   (5) Calamitous magnanimous pretenders
Message-Id: <20080311020640.DC6F326F991@magilla.localdomain>
Date: Mon, 10 Mar 2008 19:06:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This and 1-3/6 look OK to me.  But, since this one appears to be changing
the sense of the return value from send_signal, I think you should at least
take the opportunity to add a comment to send_signal saying clearly what
its return conventions are.


Thanks,
Roland
