Return-Path: <linux-kernel-owner+w=401wt.eu-S1760954AbZBLWN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954AbZBLWN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 17:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbZBLWNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 17:13:20 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:50972 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbZBLWNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 17:13:19 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: fweisbec@gmail.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       oleg@redhat.com, travis@sgi.com, a.p.zijlstra@chello.nl,
       mm-commits@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: + work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch  added to -mm tree
References: <200902031058.n13AwOoK016719@imap1.linux-foundation.org>
	<20090203121147.GB19979@elte.hu>
	<c62985530902030858y28906b2dh511c5868afabfd17@mail.gmail.com>
	<20090203112529.26e6bf76.akpm@linux-foundation.org>
	<m18wobcrw3.fsf@fess.ebiederm.org>
	<20090212124835.2fc41620.akpm@linux-foundation.org>
	<m1eiy3z4ty.fsf@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 12 Feb 2009 14:13:06 -0800
In-Reply-To: <m1eiy3z4ty.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Thu\, 12 Feb 2009 14\:08\:09 -0800")
Message-ID: <m17i3vz4lp.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org, a.p.zijlstra@chello.nl, travis@sgi.com, oleg@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I should follow up and say that the reason I care right now, is I am
digging into pci hotplug.  One of the issues I'm fighting is that
currently I appear to need a dedicated kernel thread for each pci
hotplug slot.  It gets easy to deadlock the kernel hotplugging
a hotplug controller otherwise.

Eric

