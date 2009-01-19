Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbZASCVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbZASCVB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 21:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbZASCUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 21:20:52 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:13090 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761AbZASCUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 21:20:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZOx1pBZ7Py4fOZpsxOis+WGd1wS3d67gK52YeSn3rTJqao9gChPhYeVmSSHt8qxWVv
         Zdun5e7Ry+T6Q5KxrrxkOxAofkdrvpPhzK3ETiTSKaX2CDAK4KRH6sCd3kaDRJ/fatwN
         ACmkdxXuQAHj1WOOX+r3PXgbtqQQLh8zYTlu4=
Subject: Re: [GIT PULL -tip v3] fix 39 'make headers_check' warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1232331011.3129.4.camel@localhost.localdomain>
References: <1232287474.3130.19.camel@localhost.localdomain>
	 <20090118172800.GB22624@elte.hu>  <20090118185034.GA26908@elte.hu>
	 <1232331011.3129.4.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 18 Jan 2009 18:20:46 -0800
Message-Id: <1232331646.5570.5.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-19 at 07:40 +0530, Jaswinder Singh Rajput wrote:
> On Sun, 2009-01-18 at 19:50 +0100, Ingo Molnar wrote:
> >  
> > why does such a change introduce new code? It is duplicating existing code 
> > instead of cleaning it all up.
> > 
> 
> That's why I was requesting you to check asm/swab.h because I was in
> doubt whether we need these functions in userspace or not.
> 
> If we do not need these functions in userspace then I will clean these
> up.
> 

As part of doing the swab.h splitout it was very tempting to just stop
exporting _all_ of the asm/swab.h files now that there is a linux/swab.h.
But I ended up leaving things as they were on arches that did expose
their arch specific versions to userspace.

Just a thought.

Harvey

