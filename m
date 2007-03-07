Return-Path: <linux-kernel-owner+w=401wt.eu-S2992694AbXCGWnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992694AbXCGWnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992717AbXCGWmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:42:55 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44079 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992716AbXCGWmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:42:51 -0500
Date: Wed, 7 Mar 2007 23:41:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       rjw@sisk.pl
Subject: Re: [PATCH 11/20] x86_64: wakeup.S misc cleanups
Message-ID: <20070307224157.GD5956@elf.ucw.cz>
References: <20070307065703.GA23412@in.ibm.com> <20070307071320.GL23412@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307071320.GL23412@in.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +	movw	$0x0e00 + 'i', %ds:(0xb8012)
> +	movb	$0xa8, %al	;  outb %al, $0x80;
> +

> -	movw	$0x0e00 + 'i', %ds:(0xb8012)
> -	movb	$0xa8, %al	;  outb %al, $0x80; 	

Outbs were my debugging hacks, perhaps you can simply remove them at
this point? Not sure how useful "Linux" debug print is, it can
probably be removed, too.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
