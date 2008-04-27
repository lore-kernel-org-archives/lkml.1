Return-Path: <linux-kernel-owner+w=401wt.eu-S1763973AbYD0Ui3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763973AbYD0Ui3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 16:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbYD0UiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 16:38:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:30724 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbYD0UiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 16:38:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gW2JaznG2CbEy/k0gjOLo2Jmajh938dxRFJG3qXNyK+g85H7d/OEoyjLZsFDsKAGG0joqunoYBvJz1PvZ1V92J39rdadL/PMifPVNOIWurEWT4NK1fSgPaP7Uw8Xmc3J7BdgJE/fM8DlqlO08iEeABsyh2j9ousGGiXIpgIDdrQ=
Subject: Re: [PATCH] bitops: simplify generic bit finding functions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-sparse@vger.kernel.org
In-Reply-To: <20080427203638.GW5882@ZenIV.linux.org.uk>
References: <1209327591.14173.74.camel@brick>
	 <alpine.LFD.1.10.0804271325350.3119@woody.linux-foundation.org>
	 <1209328161.14173.77.camel@brick>
	 <20080427203638.GW5882@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Sun, 27 Apr 2008 13:38:27 -0700
Message-Id: <1209328707.14173.80.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-04-27 at 21:36 +0100, Al Viro wrote:
> On Sun, Apr 27, 2008 at 01:29:21PM -0700, Harvey Harrison wrote:
> 
> > Oh, I didn't realize, I only did this because sparse started spewing out
> > lots of:
> > include/linux/bitops.h:166:32: warning: shift too big (65536) for type unsigned long
> > 
> > due to shift by size there, and again on line 202...I just wanted something
> > that sparse wouldn't warn about and was a little easier to understand to boot.
> 
> That's a sparse problem, really.  I wonder if we simply should introduce a
> new node type: EXPR_WARN.  So that expand would generate those from things
> like division by zero/overflow/bad shift *and* emitting an insn for those
> would generate a stored warning.

Well, even though it is a sparse problem, I think my revised version was
cleaner code anyway.

> 
> Objections?

None here

Harvey

