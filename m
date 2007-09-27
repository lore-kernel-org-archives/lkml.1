Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbXI0KJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbXI0KJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 06:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbXI0KIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 06:08:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:23271 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbXI0KIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 06:08:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DLFYUfCGVU1N4RxI9li9jNX3f9JUaluyT2qQGZ9ufk/17ZvaodAbhhTBbO75+r6r3j26RVAbjcNSoHg7dt5xDIU/yH5SKYMdo11lgEJD4DBfmWJBPEpSScgacZg3hzZ3QQ/9xS2eATBS6F5qvGyCy/HxTdDZiWQHXtxwIXd3tnU=
Message-ID: <b6fcc0a0709270308i5911f64fw5120b045b641d408@mail.gmail.com>
Date: Thu, 27 Sep 2007 14:08:48 +0400
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Martin Michlmayr" <tbm@cyrius.com>
Subject: Re: Updating include/asm symlink when $ARCH changes
Cc: "Sam Ravnborg" <sam@ravnborg.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070927092521.GA27491@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070927092521.GA27491@deprecation.cyrius.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/27/07, Martin Michlmayr <tbm@cyrius.com> wrote:
> I cross compile arm and mips kernels from the same kernel tree.

You can use O= feature and skip this issue completely.

   make ARCH=mips O=../build/mips ...
   make ARCH=arm O=../build/arm ...

> When
> I build a kernel the first time with a fresh kernel tree, the
> include/asm symlink is set properly.  However, when I compile for a
> different $ARCH, the include/asm is not changed and the build fails.
>
> Would it be possible for the build system to update the include/asm
> symlink when it doesn't correspond to the architecture you're
> currently trying to build for?
