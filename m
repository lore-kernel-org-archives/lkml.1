Return-Path: <linux-kernel-owner+w=401wt.eu-S1760774AbYFPIJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760774AbYFPIJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 04:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760083AbYFPIJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 04:09:25 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48606 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753949AbYFPIJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 04:09:23 -0400
Date: Mon, 16 Jun 2008 03:09:21 -0500
From: Paul Jackson <pj@sgi.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: mingo@elte.hu, tglx@linutronix.de, steiner@sgi.com, travis@sgi.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, ying.huang@intel.com,
       andi@firstfloor.org, akpm@linux-foundation.org
Subject: Re: [PATCH 7/8] x86 boot: show pfn addresses in hex not decimal in
 some kernel info printks
Message-Id: <20080616030921.18dd44d2.pj@sgi.com>
In-Reply-To: <86802c440806160005q151ee44drac956dc0a3048643@mail.gmail.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
	<20080616063016.14597.78459.sendpatchset@polaris-admin.engr.sgi.com>
	<86802c440806160005q151ee44drac956dc0a3048643@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai wrote:
> wonder if we need 0x?

It is not essential, but it seems like a good idea, to make it clear to
the reader that it is hex output, not decimal.  Especially since this
patch changes this from decimal to hex, we cannot count on some never
changing standard to help users disambiguate output.

Hex numbers that don't have A-F letters could be decimal numbers

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
