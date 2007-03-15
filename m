Return-Path: <linux-kernel-owner+w=401wt.eu-S933439AbXCOTst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439AbXCOTst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933259AbXCOTst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:48:49 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:46009 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933233AbXCOTsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:48:47 -0400
X-Sasl-enc: yqdtimQGDB0LupCzK85RZSDP5k0DWpbsour2y/58beyy 1173988124
Date: Thu, 15 Mar 2007 16:48:40 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: linux-acpi@vger.kernel.org, Chris Wedgwood <cw@f00f.org>,
       ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>
Subject: Re: [ibm-acpi-devel] [PATCH] ACPI: ibm-acpi: allow module to load when acpi notifiers can't be set
Message-ID: <20070315194840.GF14394@khazad-dum.debian.net>
References: <20070315071019.GA22613@tuatara.stupidest.org> <20070315175113.GA6596@khazad-dum.debian.net> <20070315122654.468bdd39.kristen.c.accardi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315122654.468bdd39.kristen.c.accardi@intel.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007, Kristen Carlson Accardi wrote:
> this patch gives me the following compile error:
> 
> drivers/acpi/ibm_acpi.c: In function ???ibm_init???:
> drivers/acpi/ibm_acpi.c:2605: warning: implicit declaration of function ???ibm_exit???
> drivers/acpi/ibm_acpi.c: At top level:
> drivers/acpi/ibm_acpi.c:2616: warning: conflicting types for ???ibm_exit???
> drivers/acpi/ibm_acpi.c:2616: error: static declaration of ???ibm_exit??? follows non-static declaration
> drivers/acpi/ibm_acpi.c:2605: error: previous implicit declaration of ???ibm_exit??? was here

Fixed in v2.  I developed it against acpi-test, which has a header file that
prototypes ibm_exit, and sent it before it finished compiling on 2.6.21.
Drat, that teaches me about not waiting for these things...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
