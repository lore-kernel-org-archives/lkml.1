Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbZCJOOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbZCJOOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbZCJOO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:14:26 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:26597 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbZCJOOY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:14:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IYk9EfswqiJgXrfLl+CELZSr4mS/zRWl6ZRpA6rmQtqxcJh7IboAJZPrQ9bPgy2HvQ
         gJuDidFoPDPykU0KoNZ/icqpWLkT62pD2R2yL19uoablBJnkAxk9sKM8CUSxTHo7YyD5
         9UloLE3fBdtVRbVuPLfOuZqSG05cBhUoYC1uM=
MIME-Version: 1.0
In-Reply-To: <395C6DBC66158B4CA921D1A81BB7BE7CD03C8E44@EXVMBX015-1.exch015.msoutlookonline.net>
References: <AQHJoPWWqT8cj3jW/ESeGeIz5tGf9A==>
	 <395C6DBC66158B4CA921D1A81BB7BE7CD03C8E44@EXVMBX015-1.exch015.msoutlookonline.net>
Date: Tue, 10 Mar 2009 09:14:22 -0500
Message-ID: <3bd6b93c0903100714h707e2c62re2c2165cde7674a7@mail.gmail.com>
Subject: Re: Where to get a Kernel tree with KGDB patched? -- help needed
From: Bruce Ashfield <bruce.ashfield@gmail.com>
To: Stuart Xu <sxu@soleranetworks.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 9, 2009 at 3:25 PM, Stuart Xu <sxu@soleranetworks.com> wrote:
>
> Hi,
>
> From online discussions, it seems that the linux 2.6 tree has included KGDB.  Anyone can tell me where and how to get such a kernel tree (preferably 2.6.27 ) that with KGDB patched already?

Depending on your arch, the core KGDB support is
in 2.6.27 and doesn't require additional patches. Jason
has some development items in the kernel.org  KGDB
trees, but they aren't strictly required.

Bruce

>
> I tried to use git-checkout, but got a error:
>
> git-checkout git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus
> fatal: Not a git repository
>
> Thanks,
>
> Stuart
>
> The information in this e-mail and in any attachments is confidential and may be privileged.  If you are not the intended recipient, please destroy this message, delete any copies held on your systems and notify the sender immediately.  You should not retain copy or use this e-mail for any purpose, nor disclose all or any part of its content to any other person.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
"Thou shalt not follow the NULL pointer, for chaos and madness await
thee at its end"
