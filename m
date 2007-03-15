Return-Path: <linux-kernel-owner+w=401wt.eu-S933223AbXCOTkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223AbXCOTkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933238AbXCOTkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:40:10 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:39897 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933214AbXCOTkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:40:06 -0400
X-Sasl-enc: XPeV/Hsn5ltmQXC6OTPw068WhPPiqNY4SAPSJU/hESe1 1173987605
Date: Thu, 15 Mar 2007 16:39:53 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Chris Wedgwood <cw@f00f.org>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
       kristen.c.accardi@intel.com
Subject: Re: [PATCH] ACPI: ibm-acpi: allow module to load when acpi notifiers can't be set
Message-ID: <20070315193953.GD14394@khazad-dum.debian.net>
References: <20070315071019.GA22613@tuatara.stupidest.org> <20070315175113.GA6596@khazad-dum.debian.net> <20070315191721.GB2556@tuatara.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315191721.GB2556@tuatara.stupidest.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007, Chris Wedgwood wrote:
> On Thu, Mar 15, 2007 at 02:51:14PM -0300, Henrique de Moraes Holschuh wrote:
> > This patch allows for ibm-acpi to coexist (with diminished
> > functionality) with other drivers like ACPI_BAY.
> 
> Given the ACP_IBM_BAY implementation is more complete (or seems to be,
> please comment if that isn't the case) we should probably actually
> make sure that is the *preferred* code used (on suitable hardware) at
> run time surely?

ACPI_BAY is experimental, ibm-acpi bay handling is not.  In fact, ACPI_BAY
will debut in mainline in 2.6.21, ibm-acpi bay handling sort of works since
2.6.10.

I hope to have something much better than this stopgap patch for 2.6.22, and
to deprecate ibm-acpi bay (or have it working in *cooperation* with
ACPI_BAY) for 2.6.23.

> Perhaps the IBM_ACPI_BAY code should go away and any missing
> functionality provided there should be merged into ACPI_BAY?

That's the plan, yes.  Failing that, we shall attempt to make both drivers
cooperate (not only load together, but actually work together).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
