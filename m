Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbXHSRm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbXHSRm3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 13:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbXHSRmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 13:42:22 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:35654 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbXHSRmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 13:42:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jkezXuh3Hqx5p6DDnAu3FhGuoxuk4VA6dQUfe5B0wg4R6XPLrKmXaJcBga97MQU5tXDs783yG0JgdA8BZNyVnOXe2tEtmGpoOt8om/yXJktt5Z2PIJBRQa3bWHStV6qBO5YOttts7/6K0rC0D1lCpVVedM6iHczRL6Tw/Mw4IiQ=
Message-ID: <9a8748490708191042v2309db49qc9758cf22eedc9ee@mail.gmail.com>
Date: Sun, 19 Aug 2007 19:42:19 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [no patch] Remove more double inclusions
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0708191509320.6042@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0708191509320.6042@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/08/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> Hi,
>
>
>
> Pipes for the world...
>
>         find . -type f -iname "*.[ch]" -print0 | \
>         xargs -0 grep -P '#\s*include' /dev/null | \
>         sort | \
>         uniq -c | \
>         sort -gr | \
>         less -MSi
>
> turns up all the double-inclusions. Needs someone to review, because odd
> things like
>
I believe I've already got patches for almost all of these sitting in
-mm & various subsystem trees.
Most of them will probably hit mainline during the next merge window,
so before doing a lot of duplicate work I'd suggest waiting for
2.6.24-rc1 before working on this any further - or at least check -mm
and the various maintainer/subsystem trees first.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
