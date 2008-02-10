Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbYBJCDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbYBJCDQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 21:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYBJCCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 21:02:55 -0500
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:40833 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751751AbYBJCCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 21:02:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=hwIlmVacynZ23TCXQ2i7aQnTtueADrvbOLMwGJu+ZIDK8vFy3r9mUb3eldG0O97hnEiGtphM175rQaWrjPIZhY9x1yQ6Zy6gKQeVkm5451K0bNLDVYIDdE6+SJu2JdIwJNf2aBrXhVhbss8Ic8azSfLYmqVtHd4brhb9lcu6H5A=  ;
X-YMail-OSG: OBpGYRwVM1m_DemJ9hW9An95tqtxaq2nwmNzSm3NTSJqNW7ut9GinIVzdtzQ5bbqhW3KcqqxZ9CXd72HOFX8jb_6uRuiqgoGttSpXYGaBjb.CCf3k0Y-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: DMAR EHCI failures
Date: Sat, 9 Feb 2008 18:02:41 -0800
User-Agent: KMail/1.9.6
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ashok.raj@intel.com, shaohua.li@intel.com,
       anil.s.keshavamurthy@intel.com, Dave Airlie <airlied@linux.ie>
References: <47A74B02.8050704@gmail.com>
In-Reply-To: <47A74B02.8050704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802091802.41596.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 February 2008, Jiri Slaby wrote:
> Hi,
> 
> I have this in dmesg:
> DMAR:[DMA Write] Request device [00:02.0] fault addr ee1512000
> DMAR:[fault reason 05] PTE Write access is not set
> PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
> DMAR:[DMA Read] Request device [00:1d.7] fault addr 7d5f0000
> DMAR:[fault reason 06] PTE Read access is not set
> DMAR:[DMA Read] Request device [00:1a.7] fault addr 7d5f1000
> DMAR:[fault reason 06] PTE Read access is not set
> PCI-GART: No AMD northbridge found.
> DMAR:[DMA Read] Request device [00:1a.2] fault addr 7d5f7000
> DMAR:[fault reason 06] PTE Read access is not set
> 
> CONFIG_DMAR=y
> CONFIG_DMAR_GFX_WA=y
> CONFIG_DMAR_FLOPPY_WA=y
> 
> Without the gfx workaround, there is much more output regarding 00:02.0. Is 
> there problem with broken hw, bios or drivers?

No idea.  Someone who knows the DMA Remapping stuff should have
an answer.  Presumably it works with DMAR disabled, yes?  If so,
then just don't use DMAR.  :)


> /sys/firmware/acpi/tables/DMAR:
> http://www.fi.muni.cz/~xslaby/sklad/DMAR.bin
> dmesg:
> http://www.fi.muni.cz/~xslaby/sklad/DMAR.dmesg
> 
> # for a in 00:02.0 00:1d.7 00:1a.7 00:1a.2; do lspci -vxxx -s $a; done
> 00:02.0 VGA compatible controller: Intel Corporation 82G33/G31 Express 
> Integrated Graphics Controller (rev 02) (prog-if 00 [VGA controller])
>          ... deletia ...
> 


