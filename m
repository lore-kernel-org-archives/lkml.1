Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbYDWWoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbYDWWoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 18:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbYDWWnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 18:43:53 -0400
Received: from el-out-1112.google.com ([209.85.162.181]:23501 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbYDWWnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 18:43:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gCB81SKMVTVEJmNhmzPfO3ACkI3bShoIfqjrEN3hRRdXUuXcGDkpQVv5MwfV/JB8jxSZ3tdt2AkgzHYbqnYP0ujFykYKys7R8Y85F44/MFcRqBkXlojgFocOrJOBUIltOQqloiqd8XZa6bXECgUN4PIiQspTEOWQonq5zmXUL4M=
Message-ID: <9a8748490804231543h1203ff59i466e1ea9c02af0f2@mail.gmail.com>
Date: Thu, 24 Apr 2008 00:43:51 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "devzero@web.de" <devzero@web.de>
Subject: Re: make cloneconfig ?
Cc: linux-kernel@vger.kernel.org, agruen@suse.de
In-Reply-To: <251459002@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <251459002@web.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/04/2008, devzero@web.de <devzero@web.de> wrote:
> any reason why "make cloneconfig" never made it into mainline?
>
>  many people are quite used to it and every time i build vanilla kernel i step into that trap  "oh - that`s a suse`ism"
>
>  make cloneconfig exists since /proc/config.gz - but while that one went into mainline, cloneconfig never did.
>
>  anyone know the reason for that ?
>
>  i wished, distros kernels were more similar to vanilla kernels - so what about making them more similar ?
>
>

Isn't "cloneconfig" basically just "zcat /proc/config.gz > .config &&
make oldconfig" ???   If so, why do we need yet another "make
<some_target>" Makefile rule? What would actually be gained?

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
