Return-Path: <linux-kernel-owner+w=401wt.eu-S1761618AbYBTRw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761618AbYBTRw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760352AbYBTRwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:52:38 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:33187 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760277AbYBTRwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:52:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=F7xtJxUESW6rPh2DeiREOL/EgttkQ27qgV2IqIb8uKtf/jZTWGwRn2PewdCNHVGZHwo68RR8oNEdC83gzaHjIYQG7nIXkhcHKDuPSI8/CovyqJReAzi3ndCWumIc07YTOWlQuLXrN8CiAQG0AEcnWjo2vDJlYGwuLkhrW9YPO1c=
Date: Wed, 20 Feb 2008 20:52:11 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUESTION] FRV: linking error?
Message-ID: <20080220175211.GB6733@cvg>
References: <20080218200302.GA6741@cvg> <19148.1203512465@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19148.1203512465@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[David Howells - Wed, Feb 20, 2008 at 01:01:05PM +0000]
| Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > being see over vmlinux.lds for FRV architecture I found the string:
| > 
| > 	. = ALIGN(4096);
| > 	.data.page_aligned : { *(.data.idt) }
| > 
| > though the PAGE_SIZE is 16K. Can't figure out why is that...
| > Do you have a few spare minutes to explain, please?
| 
| Ummm...  Good question.  Probably a legacy thing.  I think the .data.idt
| section is also an x86-only thing and should be dispensed with for FRV.
| Leastways, the section has nothing in it according to the link map.
| 
| David
| 
Oops ;) Thanks, David

		- Cyrill -
