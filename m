Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbYGLSoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbYGLSoq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 14:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYGLSoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 14:44:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:39193 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbYGLSoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 14:44:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EWe2GSRdH5m/Z7oW1HxjDe9pEsZK/2or4gdrfThWUxLxXNCM9hgMQsGxGTkC2Iu/L8
         j54T84gpliDgzr3W9f44ATU2m/qWZzulwnSuI94aE8klndeMoDAd7VS0GHVLhnyC3lMg
         C0yitur64U8aQ0p1ZUFPmDZwKeJyU+Iujsruk=
Message-ID: <86802c440807121144s12a43a6fl6a74cbe60b270ac8@mail.gmail.com>
Date: Sat, 12 Jul 2008 11:44:36 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: [PATCH 6/6] x86-64: Support for multiple MSIs
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, grundler@parisc-linux.org,
       tglx@linutronix.de, jgarzik@pobox.com, linux-ide@vger.kernel.org,
       suresh.b.siddha@intel.com, benh@kernel.crashing.org,
       jbarnes@virtuousgeek.org, rdunlap@xenotime.net, mtk.manpages@gmail.com,
       ebiederm@xmission.com, "Matthew Wilcox" <willy@linux.intel.com>
In-Reply-To: <20080712163024.GA14894@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080711211559.GV14894@parisc-linux.org>
	 <1215811018-15270-6-git-send-email-matthew@wil.cx>
	 <20080712055444.GA13420@elte.hu>
	 <20080712163024.GA14894@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2008 at 9:30 AM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Sat, Jul 12, 2008 at 07:54:44AM +0200, Ingo Molnar wrote:
>> hm, please implement this symmetrically on 64-bit and 32-bit as well.
>> That will need more IRQ infrastructure changes but that should be OK as
>> it will reduce the gap between the 32-bit and 64-bit side instead of
>> widening it. A good starting point would be to unify/generalize the IRQ
>> vector allocators. (and that would get most of what you need for
>> multi-vector MSI)
>
> OK, I'll look into unifying them on Monday.  Thanks for the review.
>
to make ioapic_32.c like ioapic_64.c
we should remove the irqbalance in kernel for 32bit?

YH
