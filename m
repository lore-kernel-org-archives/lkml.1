Return-Path: <linux-kernel-owner+w=401wt.eu-S1757682AbXJCOZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682AbXJCOZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 10:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbXJCOZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 10:25:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55117 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbXJCOZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 10:25:17 -0400
Date: Wed, 3 Oct 2007 23:25:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, mikpe@it.uu.se, shiwh@cn.fujitsu.com
Subject: Re: [PATCH 1/3] signal(i386): alternative signal stack wraparound
 occurs
Message-Id: <20071003232509.929160f1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200710031346.l93DkWbE028800@harpo.it.uu.se>
References: <200710031346.l93DkWbE028800@harpo.it.uu.se>
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2007 15:46:32 +0200 (MEST)
Mikael Pettersson <mikpe@it.uu.se> wrote:
> The proposed kernel signal delivery patch only handles the case
> where the /sigframe/ ends up overlapping the end of the altstack.
> If the sigframe remains within the altstack boundaries but the
> user-space signal handler adds an /ordinary stack frame/ that
> moves SP beyond the altstack limit, then the kernel patch solves
> nothing and recursive signals will cause altstack wraparound.
> 
> On the other hand, the user-space technique of making the lowest
> page(s) in the altstack inaccessible handles both cases of overflow.
> 
Hmm, okay. Then, this fix is not enough. I see.
I'll consider how to eduacate users.

Thanks,
-Kame
