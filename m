Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbXDYABa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbXDYABa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 20:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbXDYABa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 20:01:30 -0400
Received: from hu-out-0506.google.com ([72.14.214.233]:20827 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbXDYAB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 20:01:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WxIIEMODXYiNZSr59GKzkzWr+YIK4OSpGkTKyFYkkWgfs4stwpF3VT4BjomclqER/i2V9qFD4UIYO58SbZYkm16Eo3X9ySnoScru8lDV/qzY5WJUn4e9PJLe0ic+LKDKAnurezKgH+jvwrQ5c3gTvOIWjXaw88jHvOQF/AoKD5Y=
Message-ID: <f4e013870704241701y748cd32esfd8dd79658797320@mail.gmail.com>
Date: Tue, 24 Apr 2007 17:01:24 -0700
From: "Mark Hull-Richter" <mhullrich@gmail.com>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Subject: Re: Kernel traces coming back with trash/clutter
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.0.98.0704241944270.26721@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f4e013870704241640q5a723664l2fda780a24f9b40e@mail.gmail.com>
	 <alpine.DEB.0.98.0704241944270.26721@sigma.j-a-k-j.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/07, John Anthony Kazos Jr. <jakj@j-a-k-j.com> wrote:
> >
> > I am getting this odd content in the trace log (dmesg), and I cannot
> > figure out what it is or why it is there.
> >
> > <7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7>
> > <7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7>
> > <7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7>
> > <7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7>
> > <7><7><7><7><7>__bio_add_page: 2x ph 88>=128 || hw 88>=88 || 360448>max
> > ffffffff802525d8 generic_make_request(bio 000001017c745300) 50729472, 704
>
> "<7>" is KERN_DEBUG in <include/linux/kernel.h>, used with printk. Are you
> using printk in the following forms?
>
> printk(KERN_DEBUG "A debug message.\n");
>
Yes, exclusively.

> Perhaps you have something looping that's outputting KERN_DEBUG with a
> null message? Or one of your diagnostic printk statements includes
> KERN_DEBUG with no actual message?
>
No, they are all KERN_DEBUG<space>"some string here", almost all with
some formatted output as well.  Could I be overloading the printk
output buffer, as in possibly too tightly repeated/looped code to be
able to output it all?

> Remember, if you have a string in a variable without a KERN_*
> prependation, you can do this.
>
> printk(KERN_DEBUG "%s\n", debug_message);
>
Haven't tried that one - they're all of the form above.

Thanks again.

-- 
Mark Hull-Richter, Linux Kernel Engineer
DATAllegro (www.datallegro.com)
85 Enterprise, Second Floor, Aliso Viejo, CA  92656
949-680-3082 - Office     949-330-7691 - fax
[This message is NOT SPAM and is sent in strict accordance with
Google, Yahoo, AOL, Netscape and Earthlink Terms of Service.  If you
are NOT receiving this through a group and do not want any more emails
from me, please reply to me and let me know.  If you are receiving
this second-hand, this sender disclaims all responsibility for your
response.]
