Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbXHZWUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbXHZWUr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 18:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbXHZWUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 18:20:40 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:17287 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbXHZWUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 18:20:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kbn7y8q0+wX4Zl17ujaJZuYy0UnyKghBBvXZX0nhy2Iy5BG12WFl7bZYKMVefZTFCQWOU4cdG3sonj8d3HaeluHcdCzwHbLfB6lwMQK7B//RSKxJau5Yxj/AQHf9QGv648I5eVE+UzQJwhSsmsvG3yb0W6ir8FhGa0OMTGvO6Ek=
Message-ID: <9a8748490708261520h74e97bb5sc486b1cf8294c686@mail.gmail.com>
Date: Mon, 27 Aug 2007 00:20:39 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
Subject: Re: Compiling 2.6.22.5 on Debian Etch (internal compiler error)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46D1FA57.60601@mandic.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46D1FA57.60601@mandic.com.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/08/07, Renato S. Yamane <renatoyamane@mandic.com.br> wrote:
> Can someone help me with this?
>
> $ make xconfig
> HOSTCC  scripts/basic/fixdep
> scripts/basic/fixdep.c: In function 'parse_dep_file':
> scripts/basic/fixdep.c:399: internal compiler error: segmentation fault
> Please submit a full bug report,
> with preprocessed source if appropriate.
> See <URL:http://gcc.gnu.org/bugs.html> for instructions.
> For Debian GNU/Linux specific bug reporting instructions,
> see <URL:file:///usr/share/doc/gcc-4.1/README.Bugs>.
> Preprocessed source stored into /tmp/ccyzmUDF.out file, please attach
> this to your bugreport.
> make[1]: ** [scripts/basic/fixdep] Error 1
> make: ** [scripts_basic] Error 2
>

Is it repeatable or just a one-off ?

I'm using gcc 4.1.2 as well :

$ gcc --version
gcc (GCC) 4.1.2

and I don't see this - are you sure it's not a hardware problem?


You probably want to report this (as pointed out in the error message)
to the GCC folks.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
