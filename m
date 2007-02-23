Return-Path: <linux-kernel-owner+w=401wt.eu-S1751801AbXBWGTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbXBWGTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 01:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbXBWGTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 01:19:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:60191 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbXBWGTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 01:19:37 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Thomas Meyer <thomas@m3y3r.de>
Subject: AE_NOT_FOUND,  (Re: [ACPI] Several remarks for 9654640d0af8f2de40ff3807d3695109d3463f54)
Date: Fri, 23 Feb 2007 01:17:23 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <45DDEA1D.7060703@m3y3r.de>
In-Reply-To: <45DDEA1D.7060703@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702230117.23888.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 February 2007 14:08, Thomas Meyer wrote:
> 1.) My kde klaptopdaemon icon is gone. This icon displayed the remaining
> battery time. This is maybe a kde problem?
> 
> 2.) I get these new messages in the kernel log buffer:
> [...]
> ACPI: bus type pci registered
> PCI: Using MMCONFIG
> Setting up standard PCI resources
> ACPI Exception (evregion-0420): AE_NOT_FOUND, Returned by Handler for
> [EmbeddedControl] [20070126]
> ACPI Exception (dswexec-0462): AE_NOT_FOUND, While resolving operands
> for [OpcodeName unavailable] [20070126]
> ACPI Error (psparse-0537): Method parse/execution failed
> [\_SB_.PCI0.LPCB.EC__._REG] (Node c190db1c), AE_NOT_FOUND
> ACPI Exception (ec-0956): AE_NOT_FOUND, Could not use ECDT [20070126]
> ACPI: Interpreter enabled
> ACPI: (supports S0 S3 S4 S5)
> ACPI: Using IOAPIC for interrupt routing
> [...]
> ACPI Exception (evregion-0420): AE_NOT_FOUND, Returned by Handler for
> [EmbeddedControl] [20070126]
> ACPI Exception (dswexec-0462): AE_NOT_FOUND, While resolving operands
> for [OpcodeName unavailable] [20070126]
> ACPI Error (psparse-0537): Method parse/execution failed
> [\_SB_.PCI0.LPCB.EC__.SMB0.SBRW] (Node c190dbbc), AE_NOT_FOUND
> ACPI Error (psparse-0537): Method parse/execution failed
> [\_SB_.BAT0.UBSS] (Node c190da2c), AE_NOT_FOUND
> ACPI Error (psparse-0537): Method parse/execution failed
> [\_SB_.BAT0._STA] (Node c190da7c), AE_NOT_FOUND
> ACPI Exception (evregion-0420): AE_NOT_FOUND, Returned by Handler for
> [EmbeddedControl] [20070126]
> ACPI Error (psparse-0537): Method parse/execution failed
> [\_SB_.PCI0.LPCB.EC__._REG] (Node c190db1c), AE_NOT_FOUND
> ACPI Exception (evregion-0513): AE_NOT_FOUND, from region _REG,
> [EmbeddedControl] [20070126]
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> 
> But i guess this is ok and seems to be an acpi problem on my computer,
> aren't they?

Please open a bug report here:
http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI

and please attach (don't paste) the complete output from dmesg -s64000
plus the output from acpidump > acpidump.out.
If you don't have acpidump, you can get it from the latest pmtools here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/utils/

please also attach the config file you're using.

thanks,
-Len

ps. linux-acpi list added to cc:

