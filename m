Return-Path: <linux-kernel-owner+w=401wt.eu-S1761304AbYGOQiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761304AbYGOQiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbYGOQiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:38:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:55622 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbYGOQiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:38:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=c3Feg9VeFi6mCkgaeec1Y/dbOUkwPmpP75IvObepC77vtdMZsbURvZcyThz6OzUMA4
         NKNpm71sdGsVFNGTgO6isKytsqHwUCCQtzd9JtQd7uCoAk+SuFuybE50pVhws+UjQj6d
         Vjju7TJtz96dej4tEeiG5THjqSlA5QXsseWQE=
Message-ID: <86802c440807150938h39ee4991l4bee0aa2c4ad7270@mail.gmail.com>
Date: Tue, 15 Jul 2008 09:38:45 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: howarth@bromo.msbb.uc.edu, LKML <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug 11087] MMCONFIG isn't used under 2.6.26 on second generation MacBook Pro
In-Reply-To: <20080715135853.6DFEB108038@picon.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bug-11087-5966@http.bugzilla.kernel.org/>
	 <20080715135853.6DFEB108038@picon.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 6:58 AM,  <bugme-daemon@bugzilla.kernel.org> wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=11087
>
>
>
>
>
> ------- Comment #3 from howarth@bromo.msbb.uc.edu  2008-07-15 06:58 -------
> How can I generate a boot log when the boot process hangs? The first log
> section in the description of the bug is all of the boot information that I
> see. FYI, the use of pci=noacpi has no effect on the boot hang. I haven't had
> any luck finding
> a vga=XXX setting that would decrease the font size and let me see more of the
> boot messages. However I think I am seeing the critical ones starting with

please send out boot log for 2.6.25.10?

enable the boot message buffer to 18

dmesg -s 262144 > dmesg.txt

YH
