Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab0BGKlq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 05:41:46 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:33985 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab0BGKlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 05:41:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=sLwRPpgB700/uHqy9U5NgRUeQh6xytXZFWH/Fssi7GGmehwz/VilZew7HmOCFLJycX
         d//LOFHWjnDFY/cFK7cMWD7+egS0YLSacBKLLdp59m+sNAnKitc62lbj4AJnYwsew61R
         dTgacCYiE7nv1AzbfL43vi2Wui0k0Gfw1zgS4=
Message-ID: <4B6E994E.3080005@gmail.com>
Date: Sun, 07 Feb 2010 02:43:26 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.33-rc7
References: <alpine.LFD.2.00.1002061422430.3829@localhost.localdomain> <alpine.LFD.2.00.1002061445210.3829@localhost.localdomain> <20100207102016.GH3416@mail.oracle.com>
In-Reply-To: <20100207102016.GH3416@mail.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/10 02:20, Joel Becker wrote:
> On Sat, Feb 06, 2010 at 02:49:49PM -0800, Linus Torvalds wrote:
>>     Would it be ok to _only_ have the 'bz2' patches and tar-balls?
>>
>> Having two copies of every large file seems silly, if nobody really
>> requires the traditional .gz format..
>
> 	When I grab tarballs, I only grab .gz.  Bandwidth isn't a
> problem (3 minutes versus four on my DSL, I still switch over to another
> screen and check back).  But .bz2 unpacks very slowly in the
> environments I'm usually grabbing a tarball for.  I save more time
> unpacking .gz than I do downloading .bz2.
> 	That said, I'm often doing repeated unpacks, so I could easily
> turn a .bz2 into .gz when I first grab it, then use the local .gz.
>
> Joel
>


(Not sure what the spec is.)
the question is:
if converting everything to .gz,
yes is easy for everybody, because they don't
need a bzip2 or xzutils(external app),
but results in Linus's server having more mb's

as opposed to having a bzip2, or lzma(xzutils)
resulting in less mb's on the server(Linus's server)?

I guess whatever gives Linus's server less space
since he's kind enough to publish this for everybody..


Justin P. Mattock
