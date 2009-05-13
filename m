Return-Path: <linux-kernel-owner+w=401wt.eu-S1761182AbZEMSPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761182AbZEMSPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 14:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758971AbZEMSPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 14:15:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755610AbZEMSPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 14:15:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Introduce "struct wait_info" to simplify wait_task*() pathes
In-Reply-To: Vitaly Mayatskikh's message of  Wednesday, 13 May 2009 14:08:11 +0200 <1242216490-8226-2-git-send-email-v.mayatskih@gmail.com>
References: <1242216490-8226-1-git-send-email-v.mayatskih@gmail.com>
	<1242216490-8226-2-git-send-email-v.mayatskih@gmail.com>
X-Zippy-Says: I'm also pre-POURED pre-MEDITATED and pre-RAPHAELITE!!
Message-Id: <20090513181358.39DC5FC35D@magilla.sf.frob.com>
Date: Wed, 13 May 2009 11:13:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What's the benefit of this?  Those parameters are probably happily in
registers and compiled well, I would guess.  Adding more memory copying
does not seem like a benefit.  Have you verified that your change reduces
code size or something like that?


Thanks,
Roland
