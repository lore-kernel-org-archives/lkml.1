Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbXLHPLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbXLHPLK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 10:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbXLHPK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 10:10:57 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:17656 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbXLHPK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 10:10:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hc8qjGmzO8HaiAMadaskmQsTDJg1j5yLUe+rry2XNMMsRbW/TgnH6c0oUpega9b2wkTqU9mDqKqT41z+idYUWHBbyxCromMGs+qD6UhAeHlkRzuFbtnHvyBIDsOcoaRg2pkNqSZJLWnoON4DAY2j+XYP6eDXzdydBOeGSJU8q60=
Message-ID: <82e4877d0712080710g205ba93ag12ee204b15d70fdb@mail.gmail.com>
Date: Sat, 8 Dec 2007 10:10:51 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <alpine.LFD.0.99999.0712080821220.3070@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82e4877d0712071453h38795e36of26324a4b123fa6c@mail.gmail.com>
	 <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>
	 <alpine.LFD.0.99999.0712080821220.3070@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 7, 2007 9:56 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> This looks pretty much like the problem I was solving yesterday.
>
> Parag, can you please try Linus latest and please check whether there
> is a stack trace with clockevents_program_event on the top in your
> dmesg.
>

Just booted with latest git and there is no  clockevents_program_event
in dmesg anywhere.

Any way I have enabled CPU_IDLE again and the machine's got to do lot
of compiles today.
I'll see if the problem reproduces.

Thanks

Parag
