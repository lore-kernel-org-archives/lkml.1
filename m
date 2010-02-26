Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935472Ab0BZHrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 02:47:20 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:59746 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935419Ab0BZHrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 02:47:18 -0500
Date: Fri, 26 Feb 2010 08:47:14 +0100
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>, Michal Marek <mmarek@suse.cz>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH] x86: Add optimized popcnt variants
Message-ID: <20100226074714.GA15310@aftab>
References: <20100222141737.GB21233@aftab>
 <4B82BD01.3030008@zytor.com>
 <20100222184945.GD21233@aftab>
 <4B82E144.1050007@zytor.com>
 <20100223155852.GF30382@aftab>
 <4B84118C.90203@zytor.com>
 <20100223175457.GA2401@aftab>
 <4B841BC3.1000908@zytor.com>
 <20100223190614.GB2401@aftab>
 <4B875BBD.4060104@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B875BBD.4060104@zytor.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, Feb 25, 2010 at 09:27:25PM -0800

> OK, this patch looks pretty good now, but I'm completely lost as to
> what the baseline of this patch is supposed to be.

Yeah, this is based on PeterZ's http://lkml.org/lkml/2010/2/4/119

But I'm not sure which tree has it...

-- 
Regards/Gruss,
Boris.

-
Advanced Micro Devices, Inc.
Operating Systems Research Center
