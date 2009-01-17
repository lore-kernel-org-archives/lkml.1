Return-Path: <linux-kernel-owner+w=401wt.eu-S1765249AbZAQQtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765249AbZAQQtp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759849AbZAQQtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:49:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:29349 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759631AbZAQQte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:49:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ia8ToQQObFTNm/lARNoJNHlqoJkJoplJ9WLOBRl+8vuWOJgIIvxErTkcDHQKmI0tzz
         1VHGMOc8nxE/zsi2rj9w8LCpCPl8aDopfrwNXMpcdSBS2t9akZX4mHgO8xeF9K9RDJ3d
         U5Fd43Dx+4A1AWXfMpnDdZ2GpC7bkUS6zK3Yw=
Message-ID: <8db1092f0901170849i5d22d855r9ccb63182dd8dd75@mail.gmail.com>
Date: Sat, 17 Jan 2009 17:49:31 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Christian Borntraeger" <borntraeger@de.ibm.com>
Subject: Re: 2.6.29-rc1: [SOLVED] thinkpad problems during resume
Cc: "Pavel Machek" <pavel@suse.cz>, "Jeff Chua" <jeff.chua.linux@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Mike Travis" <travis@sgi.com>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <200901171648.34155.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090113081316.GA2292@elf.ucw.cz>
	 <20090116104455.GA3283@elf.ucw.cz>
	 <200901171546.15987.borntraeger@de.ibm.com>
	 <200901171648.34155.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/17 Christian Borntraeger <borntraeger@de.ibm.com>:
>
> I forgot to revert the usb patch.
> Current status:
> 2.6.29-rc2 +
> reverted e39ad415ac15116df213dfa2aa2a4f1b0857af9c (cpumask: use work_on_cpu in
> acpi-cpufreq.c for read_measured_perf_ctrs) +
> reverted a0d4922da2e4ccb0973095d8d29f36f6b1b5f703 (USB: fix up suspend and
> resume for PCI host controllers)
>
> has a working suspend to ram on my T61p. With any of these two patches not
> reverted resume hangs.
>

Great work. Thanks. On my HP Compaq nx6310 revert this patches also
helps: suspend to ram/disk works.

Thanks again :-)


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
