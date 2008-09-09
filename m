Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbYIIU2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbYIIU2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 16:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbYIIU2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 16:28:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:59308 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbYIIU2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 16:28:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=aesQw2AGCKm2ZxACfY52OTlPxfedGQJBg4gE8r3iA+PA6KJjxWU7H5iubamxi3Np3n
         K1tMVmgb4g4nMBlwWOtcuJ4QkSmnDcCd9/3dhg8fZKGvUZy6hEPPYEaor3XId+1hRfBn
         Xc9Y1uU4GSHocYZYnxifAIRu7np0pKEBvesZ8=
Message-ID: <aa79d98a0809091328q78cc7647sf99f0df415437643@mail.gmail.com>
Date: Wed, 10 Sep 2008 00:28:01 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86: io-apic - get rid of __DO_ACTION macro
Cc: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440809091313l6b3e1f48x6e3b5cd0b948ccf9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080909184615.GA7303@lenovo>
	 <86802c440809091313l6b3e1f48x6e3b5cd0b948ccf9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai, the base idea with mask is to apply a mask only if you need
it. And having _and_ operation to be mandatory implemented is a
limitation and just not enough. So that is why i do check if mask is
defined (well it cold be not a good practice indeed). Thanks for
notice (and about binary operator too - will fix :)
