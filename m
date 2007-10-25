Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbXJYRAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbXJYRAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 13:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbXJYRAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 13:00:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41149 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbXJYRAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 13:00:42 -0400
Date: Thu, 25 Oct 2007 09:56:39 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Thomas Gleixner <tglx@linutronix.de>, "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, pjones@redhat.com
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic
 runtime service support
Message-ID: <20071025095639.22f6cad0@laptopd505.fenrus.org>
In-Reply-To: <m1r6jj5e27.fsf@ebiederm.dsl.xmission.com>
References: <1193295473.23935.202.camel@caritas-dev.intel.com>
	<alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>
	<m1r6jj5e27.fsf@ebiederm.dsl.xmission.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 10:55:44 -0600
ebiederm@xmission.com (Eric W. Biederman) wrote:

> I don't think there is a compelling case for us to use any efi
> services at this time

I would almost agree with this if it wasn't for the 1 call that OS
installers need to tell EFI about bootloader stuff; I've cc'd Peter
Jones since he'll know better what OS installers need; if they don't
need it after all...

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
