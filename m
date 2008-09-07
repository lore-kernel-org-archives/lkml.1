Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbYIGQFC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbYIGQFC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 12:05:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbYIGQEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 12:04:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:6173 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbYIGQEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 12:04:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZiCxJ2ygP/1FEZJvvsb3l+JHgaRXNJAwjtjPv7Vsl+S06sGTnVttLWZh+/rIec4iGg
         SGhyewq2+isyM4wxo3CuuwUG/JdHWA73HKikvihdjnxKy/MsSaLMgZqS3svldaLZzcMx
         FW26Q4ES2p1BcFiz5f8O6BD0dDtlf5pU5vyVs=
Date: Sun, 7 Sep 2008 20:04:50 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, yhlu.kernel@gmail.com
Subject: Re: [patch 3/3] x86: io-apic - code style cleaning for
	setup_IO_APIC_irqs
Message-ID: <20080907160450.GB7515@lenovo>
References: <20080905080447.GC12409@elte.hu> <20080905180126.GA19334@lenovo> <20080905181111.GG27395@elte.hu> <20080905183347.GB19334@lenovo> <20080905183835.GA19215@elte.hu> <20080906101533.GA7273@lenovo> <Pine.LNX.4.55.0809061938250.13851@cliff.in.clinika.pl> <20080906184914.GG21872@elte.hu> <20080907100000.GA7515@lenovo> <20080907154721.GA13177@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080907154721.GA13177@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sun, Sep 07, 2008 at 05:47:21PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > here is an another attempt to satisfy the requirements :)
| > Please review and comment if it looks better or worse now.
| 
| sigh, i think the extra buffering is clearly worse. These are early init 
| printks and we already do many other cases of multi-line printouts and 
| even KERN_CONT printouts. We have a perfectly fine built-in buffer 
| already: the printk buffer.
| 
| 	Ingo
| 

ok Ingo, i think we could drop this idea then.

		- Cyrill -
