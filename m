Return-Path: <linux-kernel-owner+w=401wt.eu-S1757652AbXIFRs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652AbXIFRs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 13:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbXIFRsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 13:48:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:49173 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbXIFRsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 13:48:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oi5ItLegChAP/iYM7i96T2XOBeVAdrfTZhyP9D9fCFAykgIJAeIRhpe4Dq43TMStUCSrhP+jMh15fMZwgUbq6csEurSWW1rS+VJfZB0JsCqdIoifA8U+fq4VH3hQXSwbgcD6VXTpR1/AdfhH5OlPD6zjjBBDUiA8NqdkenTdqnQ=
Message-ID: <86802c440709061048w30021c4kad0b9d903c236896@mail.gmail.com>
Date: Thu, 6 Sep 2007 10:48:18 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space access for AMD Barcelona
Cc: "Arne Georg Gleditsch" <argggh@dolphinics.no>,
       "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       "Robert Richter" <robert.richter@amd.com>,
       "Arjan van de Ven" <arjan@infradead.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <46DFCCD9.2010306@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070903081736.288288000@amd.com>
	 <20070903154734.GC22086@alberich.amd.com> <46DE45A2.40403@zytor.com>
	 <20070905084427.GE6409@erda.amd.com> <46DE80F0.4000706@zytor.com>
	 <kjmd4wxz822.fsf@pelargir.dolphinics.no>
	 <20070905161300.GE22086@alberich.amd.com>
	 <86802c440709051542w1950e28bhb21cf5c380527a6e@mail.gmail.com>
	 <kjmps0w9ou8.fsf@pelargir.dolphinics.no> <46DFCCD9.2010306@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/6/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Well, to a first order of approximations, *all* northbridges have some
> sort of hardware registers to set mmconfig.  We were talking yesterday
> that it might just make more sense to have code for various northbridges
> to configure mmconfig directly, just like we do for IRQ routing (we
> can't trust the BIOS there, either.)

that is good idea.
