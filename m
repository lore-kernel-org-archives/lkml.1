Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbYIISou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbYIISou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 14:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbYIISom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 14:44:42 -0400
Received: from outbound-mail-03.bluehost.com ([69.89.21.13]:51176 "HELO
	outbound-mail-03.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754743AbYIISol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 14:44:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=noiWneZTBHwnU2Fp15kOIy+SObqdpQBGiP1zmwhhkB05TZ8ovbLnvg8Euv5Zbs+dqqzdY1vU8Kk8p3IAijxqakZhSY/tzy5iodypnim087Q22JZoneDrnBCyzQpmx2nC;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Seth Heasley <seth.heasley@intel.com>
Subject: Re: [PATCH 2.6.27-rc4][RESEND] irq: irq and pci_ids patch for Intel Ibex Peak DeviceIDs
Date: Tue, 9 Sep 2008 11:44:34 -0700
User-Agent: KMail/1.9.9
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, khali@linux-fr.org
References: <200808281540.59657.seth.heasley@intel.com>
In-Reply-To: <200808281540.59657.seth.heasley@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091144.35020.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 131.252.210.190 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 28, 2008 3:40 pm Seth Heasley wrote:
> This patch updates the Intel Ibex Peak (PCH) LPC and SMBus Controller
> DeviceIDs.
>
> The LPC Controller ID is set by Firmware within the range of 0x3b00-3b1f. 
> This range is included in pci_ids.h using min and max values, and irq.c now
> has code to handle the range (in lieu of 32 additions to a SWITCH
> statement).
>
> The SMBus Controller ID is a fixed-value and will not change.
>
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>

Thanks for fixing this up, Seth.  I just applied it to my linux-next branch.

Jesse
