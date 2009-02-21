Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbZBUHum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbZBUHum (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 02:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbZBUHuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 02:50:22 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:40671 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbZBUHuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 02:50:19 -0500
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, david@lang.hm,
       Matthew Wilcox <matthew@wil.cx>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>
	<alpine.DEB.1.10.0902171343280.26625@asgard.lang.hm>
	<20090217230050.GG16841@parisc-linux.org>
	<alpine.DEB.1.10.0902171506500.26625@asgard.lang.hm>
	<86802c440902171511s1abcc0eao560df4b8fcea0e7c@mail.gmail.com>
	<alpine.DEB.1.10.0902171514120.26625@asgard.lang.hm>
	<499B46B2.5040601@kernel.org>
	<alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm>
	<499B6BF7.9090300@kernel.org>
	<alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm>
	<499B724A.2040408@kernel.org>
	<alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm>
	<alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm>
	<499B774C.5010705@kernel.org>
	<alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm>
	<499B9129.50104@kernel.org> <499CD466.1060900@gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 20 Feb 2009 23:50:31 -0800
In-Reply-To: <499CD466.1060900@gmail.com> (Robert Hancock's message of "Wed\, 18 Feb 2009 21\:39\:18 -0600")
Message-ID: <m1fxi82pq0.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: hancockrwd@gmail.com, linux-pci@vger.kernel.org, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, matthew@wil.cx, david@lang.hm, akpm@linux-foundation.org, jbarnes@virtuousgeek.org, yinghai@kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Robert Hancock <hancockrwd@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0208]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] pci: enable MSI on 8132
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock <hancockrwd@gmail.com> writes:
>
> Is there a reason why we can't just enable the HT MSI mapping for any bridge
> device that has that PCI capability and is underneath an HT bridge?

The code should be under CONFIG_X86 because the rules for enabling HT MSI mappings
are different for other architectures.  But otherwise I can't think of a reason.

> Essentially
> the code for nv_msi_ht_cap_quirk could potentially be applied to all bridges as
> it is currently for NVIDIA and ALi bridges..

Sounds like it would save a fair amount of grief.

Eric
