Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbZGTTWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbZGTTWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 15:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbZGTTWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 15:22:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35181 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbZGTTWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 15:22:33 -0400
Date: Mon, 20 Jul 2009 21:22:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Doug Thompson <norsk5@yahoo.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
       Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, aris@redhat.com, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH 07/14] mce3: pass mce info to EDAC for decoding
Message-ID: <20090720192229.GC16072@basil.fritz.box>
References: <20090720180446.GB16072@basil.fritz.box> <935428.51568.qm@web50110.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <935428.51568.qm@web50110.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The goal is to have a default handler within the kernel and a more specific handler in a module after it has loaded. Using the weak symbol as a mechanism to do that. I haven't used that, so I don't know if it works.

weak symbols don't work over kernel modules.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
