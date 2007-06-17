Return-Path: <linux-kernel-owner+w=401wt.eu-S1760678AbXFQOZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760678AbXFQOZA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 10:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759862AbXFQOY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 10:24:28 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:16181 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758563AbXFQOYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 10:24:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=qexU+7z0U9DEM7ckm/TTcO76s2S/dQGn0VzzJuSX9vMeV1DgQ6PPCeXK+KRJFaopYI34tAagWl/1SJuXOmWrAEnjMFE9jbWoHiPAo+AGhIQylM5sFC/Xa5/kmpJV0yO9giQELmKaADvRZc2JYHwuRiLrPpQEpDqweFFgwBXsHYw=
Message-ID: <46754400.2080101@googlemail.com>
Date: Sun, 17 Jun 2007 16:24:00 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, Dave Airlie <airlied@linux.ie>,
       Andrea Righi <righiandr@users.sourceforge.net>,
       Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
       Samuel Ortiz <samuel@sortiz.org>, Andrey Borzenkov <arvidjaar@mail.ru>,
       Samuel Ortiz <samuel@sortiz.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Chad Tindel <ctindel@users.sourceforge.net>,
       Dan Aloni <da-x@monatomic.org>, Jay Vosburgh <fubar@us.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, Ingo Molnar <mingo@elte.hu>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>, Paulo Pereira <pfmp.404@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [2/2] 2.6.22-rc5: known regressions with patches
References: <4675430B.2000304@googlemail.com>
In-Reply-To: <4675430B.2000304@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc5
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Memory management

Subject    : bug in i386 MTRR initialization
References : http://lkml.org/lkml/2007/5/19/93
Submitter  : Andrea Righi <righiandr@users.sourceforge.net>
Status     : patch available



Networking
Subject    : commit 9093bbb2d96d0184f037cea9b4e952a44ebe7c32 broke the bonding driver
References : http://lkml.org/lkml/2007/6/13/65
Submitter  : Dan Aloni <da-x@monatomic.org>
Handled-By : Stephen Hemminger <shemminger@linux-foundation.org>
Status     : patch available
             (I cannot find it in archives. Stephen, please resend the patch)

Subject    : no irda0 interface (2.6.21 was OK), smsc does not find chip
References : http://lkml.org/lkml/2007/6/3/16
Submitter  : Andrey Borzenkov <arvidjaar@mail.ru>
Handled-By : Samuel Ortiz <samuel@sortiz.org>
             Bjorn Helgaas <bjorn.helgaas@hp.com>
Patch      : http://lkml.org/lkml/2007/6/7/237
Status     : patch was suggested



SELinux

Subject    : very high non-preempt latency in context_struct_compute_av()
References : http://lkml.org/lkml/2007/6/4/78
Submitter  : Ingo Molnar <mingo@elte.hu>
Handled-By : Stephen Smalley <sds@tycho.nsa.gov>
             James Morris <jmorris@namei.org>
Patch      : http://lkml.org/lkml/2007/6/7/334
Status     : patch available



USB

Subject    : list_add corruption. prev->next should be next (f7d28794), but was f0df8ed4 (prev=f0df8ed4) Kernel Bug at lib/list_debug.c:33
References : http://bugzilla.kernel.org/show_bug.cgi?id=8561
Submitter  : Paulo Pereira <pfmp.404@gmail.com>
Handled-By : Alan Stern <stern@rowland.harvard.edu>
Patch      : http://bugzilla.kernel.org/show_bug.cgi?id=8561#c8
Status     : patch was suggested



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
