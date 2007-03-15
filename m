Return-Path: <linux-kernel-owner+w=401wt.eu-S1030192AbXCON13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030192AbXCON13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 09:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030178AbXCON13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 09:27:29 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:50903 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933549AbXCON12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 09:27:28 -0400
X-Sasl-enc: PvRVC0m/rNxO7wjNyrlNuJY0lrOSoPmWUw82c7ZECMIu 1173965247
Date: Thu, 15 Mar 2007 10:27:17 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Chris Wedgwood <cw@f00f.org>
Cc: Len Brown <lenb@kernel.org>, ibm-acpi@hmh.eng.br,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] ACPI_IBM_BAY can not coexist with ACPI_BAY
Message-ID: <20070315132717.GB26862@khazad-dum.debian.net>
References: <20070315071019.GA22613@tuatara.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315071019.GA22613@tuatara.stupidest.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007, Chris Wedgwood wrote:
> ACPI_IBM_BAY cannot coexist with ACPI_BAY --- it causes the IBM ACPI
> code to fail to initialize so all the IBM ACPI functionality is
> missing.  The simplest fix is to just make sure the Kconfig magic
> disallows ACPI_IBM_BAY when ACPI_BAY is enabled.
> 
> Signed-off-by: Chris Wedgwood <cw@f00f.org>

I'd really like to know why the two can't coexist, first.  And I'd really
prefer a patch that make the two load and run with bay functionality
concurrently.  ACPI_BAY doesn't work right with bay batteries, and I didn't
find a way to fix that yet (or I'd have sent in patches).

Otherwise, please change the patch to a "depends on ACPI_BAY=n ||
ACPI_BAY=m".

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
