Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbYCIPUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbYCIPUo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 11:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYCIPUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 11:20:36 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33162 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751855AbYCIPUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 11:20:35 -0400
Subject: Re: kernel BUG at drivers/scsi/aic7xxx/aic79xx_osm.c:1490!
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: FUJITA Tomonori <tomof@acm.org>
Cc: mjt@tls.msk.ru, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
In-Reply-To: <1205075315.3792.12.camel@localhost.localdomain>
References: <47D3C8A1.6040409@msgid.tls.msk.ru>
	 <20080309212916T.tomof@acm.org>
	 <1205075315.3792.12.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 09 Mar 2008 10:20:32 -0500
Message-Id: <1205076032.3792.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-03-09 at 10:08 -0500, James Bottomley wrote:
> Could you firstly tell me how much memory you have

Actually, amount is insufficient, I need to know where it is.  In dmesg
you should see something like this on boot up:

BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 0000000000097800 (usable)
 BIOS-e820: 0000000000097800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fee0000 (usable)
 BIOS-e820: 000000003fee0000 - 000000003fee9000 (ACPI data)
 BIOS-e820: 000000003fee9000 - 000000003ff00000 (ACPI NVS)
 BIOS-e820: 000000003ff00000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)

If you could attach your version, that would be great.

Thanks,

James


