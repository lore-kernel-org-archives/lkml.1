Return-Path: <linux-kernel-owner+w=401wt.eu-S1753703AbXLGXby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbXLGXby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 18:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbXLGXbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 18:31:45 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:35880 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbXLGXbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 18:31:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PZpC/UrtNJYkZOKZO+f56LpviLERb0dDtOroiemQe7uH0JrPYz5oOR2T7KzWaOUm/cAm3T3BW6VUmLyIuaBryRQEIDQwAkSocHx1G7XcOR0P9J5KPdKOOMdX6EAk4foY2hj0ujE4C3ot4gXJIGCtXAa1vAvUci/LRj4nL1Tc1Pc=
Message-ID: <82e4877d0712071531h53dc7e3cncd7ab5ff090cada1@mail.gmail.com>
Date: Fri, 7 Dec 2007 18:31:43 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82e4877d0712071453h38795e36of26324a4b123fa6c@mail.gmail.com>
	 <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 7, 2007 6:12 PM, Pallipadi, Venkatesh
<venkatesh.pallipadi@intel.com> wrote:

> Looks like tick_broadcast_lock did not get freed in some path.
> You do not see this when you CPU_IDLE is not configured?
>
> Thanks,
> Venki
>

No, I did not see this prior to enabling CPU_IDLE.

All previous kernels without CPU_IDLE also had soft lockup detection enabled.

Parag
