Return-Path: <linux-kernel-owner+w=401wt.eu-S1161111AbXBMHgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161111AbXBMHgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 02:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161108AbXBMHgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 02:36:43 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:38212 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751164AbXBMHgm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 02:36:42 -0500
From: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: Len Brown <lenb@kernel.org>
Subject: Re: /proc/acpi/ac_adapter/AC is missing after latest ACPI merge
Date: Tue, 13 Feb 2007 09:36:34 +0200
User-Agent: KMail/1.9.6
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Lebedev, Vladimir P" <vladimir.p.lebedev@intel.com>
References: <200702122045.34951.ismail@pardus.org.tr> <200702130023.15495.lenb@kernel.org>
In-Reply-To: <200702130023.15495.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702130936.37764.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 February 2007 07:23:15 Len Brown wrote:
> On Monday 12 February 2007 13:45, Ismail Dönmez wrote:
> > Hi all,
> >
> > After latest ACPI merge /proc/acpi/ac_adapter/AC has gone fishing :
> >
> > [~]> ls -al /proc/acpi/ac_adapter/
> > dr-xr-xr-x  2 root root 0 Şub 12 20:44 ADP1
> >
> > [~]> ls -al /proc/acpi/ac_adapter/ADP1
> > -r--r--r-- 1 root root 0 Şub 12 20:44 state
> >
> > This at least breaks HAL which thinks AC is always plugged in, is this
> > change intentional?
>
> no change intended here.
>
> grep CONFIG_ACPI_AC .config
>
> lsmod |grep ac


[~/GIT/linux-2.6]> grep CONFIG_ACPI_AC .config
CONFIG_ACPI_AC=y

[~/GIT/linux-2.6]> lsmod|grep ac
af_packet              19976  2
cpufreq_userspace       3732  0

But it looks like older kernels had only  /proc/acpi/ac_adapter/ADP1 and it 
worked fine with HAL, maybe something in sysfs changed? Also for some reason 
hal-addon-acpi doesn't seem to start at all, which might be the problem.

Regards,
ismail
