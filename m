Return-Path: <linux-kernel-owner+w=401wt.eu-S932253AbXC1QwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253AbXC1QwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 12:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932960AbXC1QwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 12:52:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:22769 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253AbXC1QwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 12:52:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OGZBO7AJCrwEdACitgKHN5nhnbxNQcsouLUnDnGXYQ9cvBUfIttFztPr2Oue8GcYL/5tFINrRf3UaO04ZcRfP82gQ8H2ggocFj3PkF8Uh1mOMDsnq4wPfHURzHW8PRqCtc1P2D+kax9kLHwv/b0CDL/lplocmnFOWdHMWQlTbfc=
Message-ID: <6bffcb0e0703280951h47fbb597wea2f37a6f1412644@mail.gmail.com>
Date: Wed, 28 Mar 2007 18:51:56 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: Linux 2.6.21-rc5
Cc: "Andi Kleen" <ak@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Philippe Elie" <phil.el@wanadoo.fr>
In-Reply-To: <Pine.LNX.4.64.0703281809510.29565@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
	 <46096834.5050508@googlemail.com> <200703281630.59191.ak@suse.de>
	 <460A8203.20207@googlemail.com>
	 <Pine.LNX.4.64.0703281809510.29565@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/03/07, Jiri Kosina <jikos@jikos.cz> wrote:
> On Wed, 28 Mar 2007, Michal Piotrowski wrote:
>
> > BUG: using smp_processor_id() in preemptible [00000001] code: mount/7245
> > is fixed, thanks.
> > but I still get this
> > [  208.523901] =================================
> > [  208.529739] [ INFO: inconsistent lock state ]
> > [  208.534087] 2.6.21-rc5-g28defbea-dirty #131
> > [  208.538260] ---------------------------------
> > [  208.542611] inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
> > [  208.548600] swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
>
> Perhaps something like the one below?
>

Problem seems to be fixed. Thanks!

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
