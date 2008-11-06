Return-Path: <linux-kernel-owner+w=401wt.eu-S1751780AbYKFTZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbYKFTZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 14:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750804AbYKFTY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 14:24:59 -0500
Received: from web63901.mail.re1.yahoo.com ([69.147.97.116]:23140 "HELO
	web63901.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750733AbYKFTY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 14:24:59 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Nov 2008 14:24:59 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=G+QwUYAiNm98HTsiqG5LaSIKv2OfJHy7nSnMLCeENAFbAHI0x0LGtlZsxXT3zyxGmshSf1zfgdu52eCKoB1LTop7rI+vF8VlmchE9l/ZO7QnrOjMwzV76BH12fY81gd1kHMAWtkDXzAVEyuZPU1u6N1Qfx/J0gB+vN5gcM6rYNE=;
X-YMail-OSG: N78CwGkVM1mVA03hzicsDDW3MLIUh16oVCgEF81bRUgT_fzJySyHTTbT1Rh9qAHqyFZn3Ly_iQdeii_qFFzJKbw02fwuYXQ12.OngBPPq6SHabra0885rzbjUUoCgInqzSsWs7t0xp8OF_YERE6qOBuC134-
X-Mailer: YahooMailWebService/0.7.260.1
Date: Thu, 6 Nov 2008 11:18:17 -0800 (PST)
From: arvind vasudev <arvind_vasudev2000@yahoo.com>
Reply-To: arvind_vasudev2000@yahoo.com
Subject: Question about allocating resources for a hotplug device
To: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <339187.36838.qm@web63901.mail.re1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increasing the scope to include more people.

Thanks,
Arvind.

--- On Wed, 11/5/08, arvind vasudev <arvind_vasudev2000@yahoo.com> wrote:

> From: arvind vasudev <arvind_vasudev2000@yahoo.com>
> Subject: Question about allocating resources for a hotplug device
> To: linux-pci@vger.kernel.org
> Date: Wednesday, November 5, 2008, 11:43 AM
> Hello,
> 
> I am not sure if this is the right place to ask this
> question, so please let me know if there is another list
> that I should post this on.
> 
> The question is that I am hotpluging a bridge in a slot,
> and plugging in a device behind the bridge. When I do this,
> I can see that the kernel enumerates the bridge and the
> device (assigns bus and device numbers to them), but it
> fails to allocate the memory resource that the new device is
> requesting for 1MB. After tracing the kernel code (version
> 2.6.23), I can see that call to pci_bus_assign_resources()
> fails. In the normal initialization sequence, it appears as
> though the BAR registers of a device have to be initialized
> before the call to pci_bus_assign_resources(), possibly by
> the BIOS.
> 
> How should the BAR registers of the new device be
> initialized in the case of hotplug?
> 
> Thanks,
> Arvind.
> 
> 
> 
>       
> --
> To unsubscribe from this list: send the line
> "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html


      
