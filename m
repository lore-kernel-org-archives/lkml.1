Return-Path: <linux-kernel-owner+w=401wt.eu-S1762988AbXLOStK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762988AbXLOStK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 13:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbXLOSs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 13:48:57 -0500
Received: from hs-out-0708.google.com ([64.233.178.242]:4986 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755404AbXLOSs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 13:48:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:reply-to:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type;
        b=WPCsEaYVgDuvEIWD2Rs2HfO7cz2ZNM06wqZj8eGQiSZo6LzzNYtwmg361RjqaX29zlHI9kOGrlkvP6anWKE1e+FSTJkzWTUZYdbZG9ywWtaPfe6dwpKATPP0hwJXmgAkIDyzlnH9R+klmNB4enRna2uS0NMuvEdF/hUKFDZHE84=
Date: Sat, 15 Dec 2007 13:48:47 -0500 (EST)
From: Parag Warudkar <parag.warudkar@gmail.com>
X-X-Sender: parag@mini.warudkars.net
Reply-To: parag.warudkar@gmail.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: Parag Warudkar <parag.warudkar@gmail.com>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
In-Reply-To: <alpine.LFD.0.99999.0712150907180.6933@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0712151340060.3807@mini.warudkars.net>
References: <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>
  <alpine.LFD.0.99999.0712101117300.11977@localhost.localdomain> 
 <82e4877d0712102049g4830a573n86b7f72f31a42f11@mail.gmail.com> 
 <200712141817.47581.lenb@kernel.org> <82e4877d0712141651j3965fd85ged2cefed5336e1ef@mail.gmail.com>
 <alpine.LFD.0.99999.0712150907180.6933@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Dec 2007, Thomas Gleixner wrote:

>I have a patch staged for Linus, which fixes a thinko in the broadcast
>code. It might be related to your problem. Can you give it a try ?

Yep - this looks promising. No soft lockups for last half an hour 
with 4-5 Wakeups from idle. It is almost smooth - jerkiness gone down by 
99%. There are still very infrequent and quick spells where the key typed 
on the keyboard takes effect a little later - but nothing like earlier.

I will run it for a little longer just to be sure - but I don't think it 
will be a problem.

Thanks Thomas.

Parag
