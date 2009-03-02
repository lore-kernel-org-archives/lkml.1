Return-Path: <linux-kernel-owner+w=401wt.eu-S1758995AbZCBRmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758995AbZCBRmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 12:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754727AbZCBRmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 12:42:39 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:35139 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbZCBRmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 12:42:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BWeM9xGT8oN1iMhJDpngn/zO4djvpHVBrA8JVpWzqvfGcUatlblpiJZ08H+FE6jqRc
         1vZZKFOmWFmWYUVGXqFnlaJG+9t0ts9YI/ekMFZcmYy0cp5nTW6GeRpzz+oExHwNUzUn
         xOJNcx/Dq3g94ALyhBGgIwBH587r1ytBgInuI=
MIME-Version: 1.0
In-Reply-To: <1236014911.18284.89.camel@penberg-laptop>
References: <1236007103.18284.83.camel@penberg-laptop>
	 <82ecf08e0903020750q3670de6u4162e4f01c847003@mail.gmail.com>
	 <1236014911.18284.89.camel@penberg-laptop>
Date: Mon, 2 Mar 2009 14:42:35 -0300
Message-ID: <82ecf08e0903020942i55e1a31bn983c2ce243e342e9@mail.gmail.com>
Subject: Re: [PATCH] crc32: remove useless __pure modifier from functions
From: Thiago Galesi <thiagogalesi@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Hmm. They're not marked as pure in the header files. Does GCC look it up
> from the object file or something for this...?

I just tested this, the answer is No :(

It only works if it's marked in the header. But when it's marked, it
works, and redundant calls are optimized.

-- 
-
Thiago Galesi
