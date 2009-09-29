Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbZI2AWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbZI2AWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 20:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbZI2AWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 20:22:17 -0400
Received: from ist.d-labs.de ([213.239.218.44]:59162 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751AbZI2AWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 20:22:16 -0400
Date: Tue, 29 Sep 2009 02:22:09 +0200
From: Florian Mickler <florian@mickler.org>
To: linux-kernel@vger.kernel.org
Subject: Re: visibility of linux source
Message-ID: <20090929022209.39557425@schatten>
In-Reply-To: <25a94d2a0909281502u2bb383aemdb44f4af8ffdc9e7@mail.gmail.com>
References: <25a94d2a0909281502u2bb383aemdb44f4af8ffdc9e7@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009 00:02:33 +0200
Taro Okumichi <tarookumichi@gmail.com> wrote:

> I have written a gcc-tracer and html-formatter that shows
> Linux's init/main.c formatted as dynamic-html including:
>  o expand macros by clicking on them
>  o expand include directives
>  o traverse c-structs
> Address:
> http://cfw.sourceforge.net/htmltag/init/main.c.pinfo.html
> I have only processed init/main.c (50mb mysql content)
> As far as I understand (maybe I am wrong) this kind of
> visibility is not achieved till now.
> Note:
> I tested firefox (3.5) and konqueror. The first page takes ~
> 10 Seconds to load, therefore be patient until the right
> side init/main.c content is shown (ajax fetch from a mysql db).
> 
> o Complete Preprocessor Trace:
>    All Macro expansions where traced and can be clicked
>    open to see how they expand and where the macro was
>    defined.
>   - to open a macro expansion: click the macro marked
>     with a white box,
>     + after the macro has been expanded you can:
>     + click the macro name to get the macro definition location
>     + a "<" link appears at the end of the macro expansion,
>        click it to close the macro expansion again.
>   - #ifdef etc. preprocessor directives
>     can also be expanded. Blocks that are inactive are
>     marked grey.
>   - #include directives can be clicked to expand to the
>     included file
> 
> o Variable/function declares are Trace:
>    Full struct type layout is traced and when a struct
>    types is used you can click on the type declarator,
> 
> To get going:
> 1. Browse to the end of init/main.c page:
> 2. click on
>     "param_check_bool" it will expand to:
>      param_check_bool __param_check ( initcall_debug , & (
> initcall_debug ) , int )[<]
>      Click on param_check_bool again, it will sow the definition pos of
>      the macro, click on "<" and it will close the expansion,
>      You can recursively ascend into for instance expanding __param_check etc...
> 
> 
> I thought to share this link to inspire some real gcc experts
> or kernel hackers to implement this kind of feature in the production
> gcc, I was using gcc-4.2.1 to output a cpp and c-parse trace
> however the code is that kind of messy and would be of no
> use, easier to implement newly, I guess that it should be obvious
> what to do for for the right person. After getting the trace I use
> a simple perl script (also messy code that I'm kind of ashamed to
> publish) to format html.
> 
> Implementation note:
> 
> Using a ajax request to retrieve the html, the Mysql db
> content is ~ 50 mb for the whole of main.c. No optimization
> is done, so this includes lots of redundant entries.
> 
> The left index frame should not be used, the javascript code
> is kind of buggy, so only use the right frame where the code
> is shown.
> 
> Also: There is a bug in when closing a "include" directive section:
> (At least in firefox) A new windows will pop up (I didnt find out
> why this is the case). Click the window to the back and continue
> (not closing it otherwise the next #include directive opens it again...
> 
> Have fun
> -- Tkokum

Wow, nice!
Come on! Don't be shy! This is called 'rapid prototyping' and is a
useful thing. Plz share your code. I'd like to play with it.

(one things come to mind: extending cscope/vi)

Sincerely,
Florian

-- 
A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?  
>> A: Top-posting.  
>>> Q: What is the most annoying thing in e-mail?
