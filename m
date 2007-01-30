Return-Path: <linux-kernel-owner+w=401wt.eu-S965312AbXA3Mo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965312AbXA3Mo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 07:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965315AbXA3Mo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 07:44:57 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:38569 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965312AbXA3Mo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 07:44:56 -0500
Date: Tue, 30 Jan 2007 06:44:17 -0600
From: Robin Holt <holt@sgi.com>
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
Cc: Robin Holt <holt@sgi.com>, akpm@osdl.org, pavel@ucw.cz,
       linux-kernel@vger.kernel.org, dhowells@redhat.com,
       alan@lxorguk.ukuu.org.uk, sugita <yumiko.sugita.yf@hitachi.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: Re: [PATCH 0/4] coredump: core dump masking support v2
Message-ID: <20070130124417.GA7320@lnx-holt.americas.sgi.com>
References: <45BA0A93.30004@hitachi.com> <20070126152907.GB30950@lnx-holt.americas.sgi.com> <45BEF582.7080004@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BEF582.7080004@hitachi.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 04:36:34PM +0900, Kawai, Hidehiro wrote:
> Hi Robin,
> 
> Robin Holt wrote:
> > Can you make this a little more transparent?  Having a magic bitmask does
> > not seem like the best way to do stuff.  Could you maybe make a core_flags
> > directory with a seperate file for each flag.  It could still map to a
> > single field in the mm, but be broken out for the proc filesystem.
> 
> It seems to be one of the good enhancement idea, thanks.:-)
> But currently, there is only one flag. So we had better keep this simple
> implementation until someone requests to add a new flag.

If that is the case, can we rename the file from core_flags to something
more descriptive like dump_core_skip_anonymous_mappings.  The name
is a wild suggestion, the renaming does seem fairly important to me.
Remember once you get this in, changing the name will be fairly difficult
as admin tools and documentation will adopt the name.  These are usually
cases where it is better to do it right the first time.

Thanks,
Robin
