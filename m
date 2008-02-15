Return-Path: <linux-kernel-owner+w=401wt.eu-S932596AbYBOGjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596AbYBOGjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 01:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758261AbYBOGjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 01:39:25 -0500
Received: from gw.goop.org ([64.81.55.164]:47297 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755892AbYBOGjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 01:39:24 -0500
Message-ID: <47B5333B.5010804@goop.org>
Date: Fri, 15 Feb 2008 17:37:47 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ian Campbell <ijc@hellion.org.uk>, Mark McLoughlin <markmc@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCHv3 1/3] x86: use ELF format in compressed images.
References: <1202936100-30859-1-git-send-email-ijc@hellion.org.uk>	<9d3a007a2bfe774201b6deed5115a0cc8182bbb4.1202935389.git.ijc@hellion.org.uk>	<1202988844.26435.4.camel@muff>	<1203008490.30818.69.camel@localhost.localdomain> <1203011834.30565.8.camel@cthulhu.hellion.org.uk> <47B4AE2A.6080300@goop.org> <47B4AF4A.2000806@zytor.com>
In-Reply-To: <47B4AF4A.2000806@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>>
>> Do you also have a patch to update the boot protocol?
>>
>
> Looking for anything different than the root of this thread?

Yes, the patch for the Xen domain builder to boot a bzImage using the 
Linux boot protocol rather than the Xen one.  Ian's patch will extract 
the ELF file from the bzImage, but still boot it by finding the Xen 
entrypoint in the notes, with %esi pointing to the Xen start_info rather 
than the boot_params (unless I'm missing something).

    J
