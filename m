Return-Path: <linux-kernel-owner+w=401wt.eu-S1759663AbYFLWOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759663AbYFLWOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbYFLWN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:13:59 -0400
Received: from relay2.sgi.com ([192.48.171.30]:39002 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754475AbYFLWN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:13:58 -0400
Date: Thu, 12 Jun 2008 17:13:54 -0500
From: Paul Jackson <pj@sgi.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: hpa@zytor.com, andi@firstfloor.org, mingo@elte.hu, bwalle@suse.de,
       hannes@saeurebad.de, ying.huang@intel.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com
Subject: Re: Confusions with reserve_early, reserve_bootmem, e820, efi, ...
 on x86_64
Message-Id: <20080612171354.b97d5da6.pj@sgi.com>
In-Reply-To: <86802c440806121506o8628227he7522c35d906664b@mail.gmail.com>
References: <20080612050609.88a8cf7f.pj@sgi.com>
	<86802c440806120525v2da860bfyf05eb8ec6b9943d0@mail.gmail.com>
	<20080612111943.c140c4cb.pj@sgi.com>
	<86802c440806121005g42f2e44cxbe5f7bdb06836a1e@mail.gmail.com>
	<20080612151032.5a59309b.pj@sgi.com>
	<86802c440806121329s54bb1e6dobaaa15c26e7dc81c@mail.gmail.com>
	<48519077.2050402@zytor.com>
	<20080612165252.b7ce6902.pj@sgi.com>
	<86802c440806121506o8628227he7522c35d906664b@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai wrote:
> what is addr that the EFI memmap should be according to spec?

The EFI memmap has no specific address by specification.  Rather the
BIOS/firmware can put it where it will, and then pass that address via
the boot_parms.efi_info.memmap field.  See include/asm-x86/bootparam.h
for these structures.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
