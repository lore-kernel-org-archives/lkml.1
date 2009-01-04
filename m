Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbZADPgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbZADPgb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 10:36:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbZADPgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 10:36:23 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:46398 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbZADPgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 10:36:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XUK3Z037rCXwH5vnmb6mUV5D0KmCNrKYRIg1QEXppmLgNR8IF7NkgJZjTk9T70cNAG
         R9OtTX/CBLxi/N7xikLoQe9ZvVLQCyit49kCu+0jz/1MV1mtNWTCLi/e5uwZmhgF8zXx
         Jq1bfPR+rFjS+rZ3LfLAKv1PZS9OE+ZsBFrpw=
Message-ID: <c62985530901040736g5d9c1f20y248d6e6c635bede3@mail.gmail.com>
Date: Sun, 4 Jan 2009 16:36:18 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH] bootchart: improve output based on Dave Jones' feedback
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, davej@redhat.com
In-Reply-To: <20090104071638.64be922a@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090104071638.64be922a@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/4 Arjan van de Ven <arjan@infradead.org>:
>
> Subject: bootchart: improve output based on Dave Jones' feedback
> From: Arjan van de Ven <arjan@linux.intel.com>
>
> Dave Jones, in his blog, had some feedback about the bootchart script:
> Primarily his complaint was that shorter delays weren't visualized.
>
> The reason for that was that too small delays will have their labels
> mixed up in the graph in an unreadable mess.
>
> This patch has a fix for this; for one, it makes the output wider,
> so more will fit.
> The second part is that smaller delays are now shown with a
> much smaller font for the label; while this isn't per se
> readable at a 1:1 zoom, at least you can zoom in with most SVG
> viewing applications and see what it is you are looking at.
>
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>


BTW, it looks like the async initcall feature has not been merged
upstream, even not in tip/master. Was it too
risky, not enough tested or something?
