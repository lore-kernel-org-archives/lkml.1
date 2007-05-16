Return-Path: <linux-kernel-owner+w=401wt.eu-S1761652AbXEPRXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761652AbXEPRXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756270AbXEPRXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:23:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50442 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757175AbXEPRXG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:23:06 -0400
Date: Wed, 16 May 2007 10:15:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?B?SvZybg==?= Engel <joern@lazybastard.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, David Chinner <dgc@sgi.com>,
       Anton Altaparmakov <aia21@cam.ac.uk>, Al Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH resend] introduce I_SYNC
Message-Id: <20070516101535.94e44b3b.akpm@linux-foundation.org>
In-Reply-To: <20070516170110.GC8113@lazybastard.org>
References: <20070516170110.GC8113@lazybastard.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 19:01:14 +0200 Jörn Engel <joern@lazybastard.org> wrote:

> This patch introduces a new flag, I_SYNC and seperates out all sync()
> users of I_LOCK to use the new flag instead.

gack, you like sticking your head in dark and dusty holes.

If we're going to do this then please let's get some exhaustive commentary
in there so that others have a chance of understanding these flags without
having to do the amount of reverse-engineering which you've been put through.
