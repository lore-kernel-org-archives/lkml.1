Return-Path: <linux-kernel-owner+w=401wt.eu-S1759672AbZEFQUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759672AbZEFQUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 12:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbZEFQU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 12:20:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52377 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbZEFQU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 12:20:26 -0400
Message-ID: <4A01B8A5.9030902@zytor.com>
Date: Wed, 06 May 2009 09:19:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tim Abbott <tabbott@MIT.EDU>
CC: Sam Ravnborg <sam@ravnborg.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 03/11] x86: Use macros for .data.page_aligned.
References: <1241136098-10376-1-git-send-email-tabbott@mit.edu> <1241136098-10376-2-git-send-email-tabbott@mit.edu> <1241136098-10376-3-git-send-email-tabbott@mit.edu> <1241136098-10376-4-git-send-email-tabbott@mit.edu>
In-Reply-To: <1241136098-10376-4-git-send-email-tabbott@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Abbott wrote:
> .data.page_aligned should not need a separate output section.  So, as
> part of this cleanup I moved it into the .data output section in the
> linker scripts in order to eliminate unnecessary references to the
> section name.

"Should not need" is one thing, but personally I find that it enhances
debuggability to not merge input sections with different attributes too
much.  They still get merged into single segments.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

