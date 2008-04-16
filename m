Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbYDPT4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbYDPT4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761403AbYDPTzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:55:51 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44039 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761066AbYDPTzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:55:50 -0400
Message-ID: <48065960.2000207@cs.helsinki.fi>
Date: Wed, 16 Apr 2008 22:54:08 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Tom Zanussi <zanussi@comcast.net>, David Wilder <dwilder@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, tzanussi@gmail.com
Subject: Re: [PATCH -mm] relayfs: support larger relay buffer take 3
References: <4804C95F.2080204@redhat.com> <1208319769.7893.16.camel@charm-linux> <48063F80.9060404@redhat.com> <Pine.LNX.4.64.0804162110070.19171@sbz-30.cs.Helsinki.FI> <480646B2.9000905@redhat.com> <480658DC.6030507@redhat.com>
In-Reply-To: <480658DC.6030507@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Use vmalloc() and memset() instead of kcalloc() to allocate a page* array
> when the array size is bigger than one page. This enables relayfs to support
> bigger relay buffers than 64MB on 4k-page system, 512MB on 16k-page system.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>

Looks good to me!

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
