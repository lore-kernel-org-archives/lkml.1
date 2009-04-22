Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbZDVRQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbZDVRQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 13:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbZDVRQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 13:16:45 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:43597 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754128AbZDVRQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 13:16:44 -0400
Date: Wed, 22 Apr 2009 13:13:47 -0400 (EDT)
From: Tim Abbott <tabbott@MIT.EDU>
To: Masami Hiramatsu <mhiramat@redhat.com>
cc: Anders Kaseorg <andersk@MIT.EDU>,
       =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>
Subject: Re: [PATCH v2 0/4] Add support for compiling with	-ffunction-sections
 -fdata-sections
In-Reply-To: <49EF01B4.6000406@redhat.com>
Message-ID: <alpine.DEB.1.10.0904221035460.24280@vinegar-pot.mit.edu>
References: <1238973278-31735-1-git-send-email-tabbott@mit.edu> <20090421140228.GC3303@hack> <alpine.DEB.2.00.0904211311110.7725@vinegar-pot.mit.edu> <49EF01B4.6000406@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009, Masami Hiramatsu wrote:

> Would you know actual version of gcc from which supports the combination of
> -ffunction-sections and -g?

The warning about combining -ffunction-sections and -g was disabled on the 
ELF target in gcc 2.95 (released August 1999).  I think that combining 
these options worked fine on ELF before then and the change in 1999 was 
just disabling the warning on a target that it didn't apply to.

	-Tim Abbott
