Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbYFCUYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbYFCUYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 16:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbYFCUY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 16:24:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751760AbYFCUY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 16:24:27 -0400
Date: Tue, 3 Jun 2008 13:22:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: mtk.manpages@gmail.com, linux-kernel@vger.kernel.org, hch@lst.de,
       miklos@szeredi.hu, viro@zeniv.linux.org.uk, jamie@shareable.org,
       drepper@redhat.com, linux-fsdevel@vger.kernel.org,
       subrata@linux.vnet.ibm.com
Subject: Re: utimensat() non-conformances and fixes [v4] (patch)
Message-Id: <20080603132231.1430f812.akpm@linux-foundation.org>
In-Reply-To: <4845A606.6070005@gmail.com>
References: <48454F1D.6060507@gmail.com>
	<4845A606.6070005@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jun 2008 22:13:58 +0200
Michael Kerrisk <mtk.manpages@googlemail.com> wrote:

> This patch fixes all of the utimensat() bugs outlined in my
> previous mail.
> 
> I could have split the patch out into a few pieces, but given
> that it is not long, and all against a single file, I've made
> one patch.  Let me know if you would like separate patches for
> the pieces below.

Well I think it would have been better, really.

Right now someone (apparently me) needs to take the text from
"utimensat() non-conformances and fixes [v4] (overview)" and weave it
together with the text from "utimensat() non-conformances and fixes
[v4] (patch)" to produce a vaguely coherent changelog.

It all would be much saner and cleaner if each of these changes was in
a self-contained diff which had its own standalone changelog, no?

