Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbYJFXGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbYJFXGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbYJFXFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:05:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:47503 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbYJFXFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:05:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=p/9OpEIBHMKqa1XvsZi4WyzoWcF0b8li0jeGGFDCJUTr4Usa+XFHb5kTt7k48g8fgU
         FxUk6mSanXGQCAbZ15NPpwu2fjGEeOQyCVDb5vxblbO/V71gGzToJlcBYMTdVdz+6v0t
         G8775VLiC08+DqCJDCLJMh9PB3v2bwwFogWJE=
Message-ID: <1865922a0810061605j54e59276mab631ec1b14d49b5@mail.gmail.com>
Date: Tue, 7 Oct 2008 01:05:51 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: "Tilman Baumann" <tilman.baumann@collax.com>
Subject: Re: SMACK netfilter smacklabel socket match
Cc: "Casey Schaufler" <casey@schaufler-ca.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
In-Reply-To: <48EA0B30.6080907@collax.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48DBC9A1.20900@collax.com>
	 <E33DFA86-F040-413F-8156-EDCB879F4CEE@collax.com>
	 <48DDBE2E.3010006@schaufler-ca.com> <48E1007F.4000400@collax.com>
	 <48E19D01.9050809@schaufler-ca.com> <48E35F36.4030203@collax.com>
	 <48E3957A.7040201@schaufler-ca.com> <48E3AB97.8020305@collax.com>
	 <48E3BFDE.7010300@schaufler-ca.com> <48EA0B30.6080907@collax.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tilman,

On Mon, Oct 6, 2008 at 2:57 PM, Tilman Baumann
<tilman.baumann@collax.com> wrote:
> If I set /smack/nltype to 'unlabeled' I have effectively shut off the
>  network.
...
> This might work well in trusted networks.
> But Internet is untrusted and needs to work too. At least in the most real
> world scenarios. :)
>
> If i set /smack/nltype to 'unlabled' i don't even get SYN packets out.
> (operation not permitted)
>
> That's probably a bug, but I think the "fix" is to disable the ability to
> set the nltype to anything other than CIPSO at least for the time being.

Check this patch:
http://article.gmane.org/gmane.linux.network/95294/match=

As far as I can remember, it does exactly what you're asking for.
There have been some arguments against it, but at least you can get
the idea and _try_ to discuss/enhance it further.

Regards

-- 
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
