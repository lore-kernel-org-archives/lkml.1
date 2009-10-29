Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbZJ2CFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbZJ2CFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 22:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbZJ2CF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 22:05:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33039 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbZJ2CF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 22:05:29 -0400
Subject: Re: [patch 1/3] x86, cpa: fix kernel text RO checks in
 static_protection()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org
In-Reply-To: <20091029024820.996634347@sbs-t61.sc.intel.com>
References: <20091029024820.996634347@sbs-t61.sc.intel.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 28 Oct 2009 22:05:32 -0400
Message-Id: <1256781932.26028.2136.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-28 at 18:46 -0800, Suresh Siddha wrote:
> plain text document attachment (fix_cpa_check.patch)
> Steven Rostedt reported that we are unconditionally making the
> kernel text mapping as read-only. i.e., if someone does cpa() to the
> kernel text area for setting/clearing any page table attribute, we
> unconditionally clear the read-write attribute for the kernel text mapping
> that is set at compile time.
> 
> We should delay (to forbid the write attribute) and enforce only after the
> kernel has mapped the text as read-only.
> 
> Reported-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Heh, I wrote an almost identical patch myself. It would have been exact,
but I did not make the comment change ;-)

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


