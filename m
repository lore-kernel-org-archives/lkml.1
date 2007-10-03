Return-Path: <linux-kernel-owner+w=401wt.eu-S1758686AbXJCUfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbXJCUfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 16:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbXJCUfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 16:35:21 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46168 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840AbXJCUfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 16:35:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Roland Dreier <rdreier@cisco.com>
Cc: Roland Dreier <roland@digitalvampire.org>, Greg KH <greg@kroah.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: MSI: Use correct data offset for 32-bit MSI in read_msi_msg()
References: <87abr0oyj4.fsf@shaolin.home.digitalvampire.org>
	<m1ir5ocaxr.fsf@ebiederm.dsl.xmission.com>
	<874ph8ovtm.fsf@shaolin.home.digitalvampire.org>
	<m17im4c6sh.fsf@ebiederm.dsl.xmission.com> <adaejgcdkyn.fsf@cisco.com>
Date: Wed, 03 Oct 2007 14:34:58 -0600
In-Reply-To: <adaejgcdkyn.fsf@cisco.com> (Roland Dreier's message of "Wed, 03
	Oct 2007 13:03:44 -0700")
Message-ID: <m11wccc4y5.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> writes:

>  > Well it is a bug worth fixing.  Who knows it may have something
>  > to do with the disable_irq problems the forcedeth driver was seeing.
>
> I agree completely, the fix looks obvious and there's no point in
> leaving the bug there.  I just don't have a test case that I can point
> to as being fixed by this, since I don't have a working 32-bit MSI
> device...
>
> Do you know whether the forcedeth devices have a 32-bit MSI address?

Sorry I don't.  The ones I have don't have an MSI capability.


Eric
