Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbYKERxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbYKERxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 12:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756556AbYKERx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 12:53:26 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:36790 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531AbYKERxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 12:53:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NGlz9FeRQfnvLSMdb/Ovseb+u/Ep59u/0gqnBFjVsuD87kf1+WnZqytu17lqfdF6dG
         zMSog5p3DDw56787xvDDwR5TusQC0ghfrAAUZk9Td7ogcwlfdlZbVJyflP/w2n7otS5T
         agliLoIxY3aNQ6gLfVGZKz5ls3moNaUMFmo1A=
Date: Wed, 5 Nov 2008 20:53:18 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Andi Kleen <andi@firstfloor.org>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       jeremy@xensource.com, Steven Rostedt <srostedt@redhat.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Message-ID: <20081105175318.GD7286@localhost>
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com> <20081104204400.GC10825@elte.hu> <20081104212933.GA11050@elte.hu> <4910C014.9070805@zytor.com> <20081104215245.GC17775@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104215245.GC17775@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Tue, Nov 04, 2008 at 10:52:45PM +0100]
| 
| * H. Peter Anvin <hpa@zytor.com> wrote:
| 
| > Ingo Molnar wrote:
| > > * Ingo Molnar <mingo@elte.hu> wrote:
| > > 
| > >> And as hpa's comments point it out, compressing the rather stupid 
| > >> irq stubs might be a third option that looks promising as well.
| > > 
| > > ... and we should try and see how far we can compress those stubs, 
| > > before we do any segment register based tricks.
| > > 
| > 
| > Using the techniques previously mentioned, for 224 vectors:
| > 
| > 1792 bytes ( 8 bytes/stub) - trivial.
| > 1568 bytes ( 7 bytes/stub) - same without alignment.
| >  952 bytes (~4 bytes/stub) - extra jump needed.
| > 
| > For comparison, the IDT itself is 2048 bytes on x86-32 and 4096 bytes on
| > x86-64.
| 
| sounds like a plan :)
| 
| 	Ingo
| 

Ingo, what the conclusion is? As I understand from the thread --

1) Implement Peter's proposed cleanup/compress.
2) Test Alexander's patche.

Did I miss something?

		- Cyrill -
