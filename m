Return-Path: <linux-kernel-owner+w=401wt.eu-S1764145AbXLNXTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764145AbXLNXTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 18:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbXLNXTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 18:19:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:56124 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756401AbXLNXTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 18:19:04 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Parag Warudkar" <parag.warudkar@gmail.com>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Date: Fri, 14 Dec 2007 18:17:47 -0500
User-Agent: KMail/1.9.5
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Arjan van de Ven" <arjan@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com> <alpine.LFD.0.99999.0712101117300.11977@localhost.localdomain> <82e4877d0712102049g4830a573n86b7f72f31a42f11@mail.gmail.com>
In-Reply-To: <82e4877d0712102049g4830a573n86b7f72f31a42f11@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712141817.47581.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

does processor.max_cstate=1 make the failing configuration work?
If yes, how about processor.max_cstate=2?

what do you see in /proc/acpi/processor/*/power?

-Len
