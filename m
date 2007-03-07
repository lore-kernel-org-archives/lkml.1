Return-Path: <linux-kernel-owner+w=401wt.eu-S2992728AbXCGWuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992728AbXCGWuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992720AbXCGWuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:50:22 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40412 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992729AbXCGWuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:50:19 -0500
Date: Wed, 7 Mar 2007 23:50:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       rjw@sisk.pl
Subject: Re: [PATCH 16/20] swsusp: do not use virt_to_page on kernel data address
Message-ID: <20070307225006.GH5956@elf.ucw.cz>
References: <20070307065703.GA23412@in.ibm.com> <20070307072008.GQ23412@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307072008.GQ23412@in.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> o virt_to_page() call should be used on kernel linear addresses and not
>   on kernel text and data addresses. Swsusp code uses it on kernel data
>   (statically allocated swsusp_header).
> 
> o Allocate swsusp_header dynamically so that virt_to_page() can be used
>   safely.
> 
> o I am changing this because in next few patches, __pa() on x86_64 will
>   no longer support kernel text and data addresses and hibernation breaks. 
> 
> Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>

(I assume this was tested, too?)
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
