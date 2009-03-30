Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056AbZC3StA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbZC3StA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbZC3Sst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:48:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57174 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbZC3Sss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:48:48 -0400
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: Re: [patch 09/35 error-handling] reiserfs: add locking around error buffer
From: Andi Kleen <andi@firstfloor.org>
References: <20090330180215.951354436@suse.com>
	<20090330181010.432220021@suse.com>
Date: Mon, 30 Mar 2009 20:48:42 +0200
In-Reply-To: <20090330181010.432220021@suse.com> (Jeff Mahoney's message of "Mon, 30 Mar 2009 14:02:24 -0400")
Message-ID: <87y6umlud1.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Mahoney <jeffm@suse.com> writes:

>  The formatting of the error buffer is race prone. It uses static buffers
>  for both formatting and output. While overwriting the error buffer
>  can product garbled output, overwriting the format buffer with incompatible
>  % directives can cause crashes.

Really? Just curious but could you describe the steps how a garbled printk can
leads to a crash?

Thanks,

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
