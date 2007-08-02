Return-Path: <linux-kernel-owner+w=401wt.eu-S1760881AbXHBUtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760881AbXHBUtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 16:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbXHBUtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 16:49:09 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:36038 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbXHBUtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 16:49:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B+pXp5HTB4R91o15sVFz0VTLJvnvfnPt3kESMBd5Xn95VfYpVnfOauHXdr9S6D45Ou6iE55hI90JjECo2g3rVUCVMCIaUuj87EY6FhNgx9zRnkOnhQ7kAkOiSI0siVCw+dwhLiKNdw5XK3RVF45Lt3kwDlkAmfb87yV1zcKiWro=
Message-ID: <9a8748490708021349h7be6df29m611a5ea0c01d1690@mail.gmail.com>
Date: Thu, 2 Aug 2007 22:49:06 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: error: implicit declaration of function 'rcu_dereference' - current -git fails to build
Cc: "Dipankar Sarma" <dipankar@in.ibm.com>, "Adrian Bunk" <bunk@stusta.de>
In-Reply-To: <9a8748490708021316o473705e9v795784973171de72@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490708021257q2f28f8d5y4fdcebaca587fe8a@mail.gmail.com>
	 <20070802201344.GZ3972@stusta.de>
	 <9a8748490708021316o473705e9v795784973171de72@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> On 02/08/07, Adrian Bunk <bunk@stusta.de> wrote:
> > On Thu, Aug 02, 2007 at 09:57:07PM +0200, Jesper Juhl wrote:
> > > I get this build error with the current mainline git tree.
> > > Let me know if further details are needed...
> > >...
> >
> > -ENODOTCONFIG
> >
>
> Attached.
>

Forget about this.

I thought I had a clean tree, but it turns out that I did not.  I had
some local (buggy) changes in there that I had overlooked. I did
  git reset --hard master
  git clean -d
and now everything builds fine with that config.

Sorry about the noise.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
