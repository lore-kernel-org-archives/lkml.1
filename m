Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbYGSTFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbYGSTFR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 15:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYGSTFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 15:05:01 -0400
Received: from outbound-mail-28.bluehost.com ([69.89.17.198]:48545 "HELO
	outbound-mail-28.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751326AbYGSTFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 15:05:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=NbCoPj1pSouBo2eO2q+nsD+cwgMXNbGqWHb3yTNlks62HMAF6biI6Yo2vhIc0dNQIsuN7npJwZIoiYlr5hYikPdBzC04KWleZw2GNoq4KEAEyZJkY0DVxd46PmBK7vdj;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jack Howarth <howarth@bromo.msbb.uc.edu>
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
Date: Sat, 19 Jul 2008 12:04:48 -0700
User-Agent: KMail/1.9.9
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>
References: <200807180941.09779.yhlu.kernel@gmail.com> <200807191026.03172.jbarnes@virtuousgeek.org> <20080719184011.GA19548@bromo.msbb.uc.edu>
In-Reply-To: <20080719184011.GA19548@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807191204.48428.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 19, 2008 11:40 am Jack Howarth wrote:
> Jesse,
>     It seems that MacBook Pro users aren't the only ones suffering from
> PCIE_ASPM...
>
> http://groups.google.com/group/linux.kernel/browse_thread/thread/cc1b8b3ef6
>4e3257/dd4e427510bde7f0?lnk=raot
>
> I also discovered the pcie_noaspm kernel option from that thread which
> allows me to boot the kernels built with PCIE_ASPM support by disabling
> that feature.

Yeah, that's a good data point.  Thanks.  Sounds like there may also be some 
ACPI interaction going on...

Jesse
