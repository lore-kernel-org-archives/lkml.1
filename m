Return-Path: <linux-kernel-owner+w=401wt.eu-S1759344AbXHXLls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344AbXHXLls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 07:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756664AbXHXLlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 07:41:40 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2488 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbXHXLlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 07:41:40 -0400
Message-ID: <46CEC3D4.40805@shadowen.org>
Date: Fri, 24 Aug 2007 12:41:08 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: false positive in checkpatch.pl (complex macro values)
References: <8bd0f97a0708240051w7fc00b01w8dc1b39fe606bfe4@mail.gmail.com>
In-Reply-To: <8bd0f97a0708240051w7fc00b01w8dc1b39fe606bfe4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> in some code that does like:
> #define foo { a, b, c, \
>     d, e, f, g }
> ...
> int boo[] = foo;
> ...
> 
> checkpatch.pl throws a fit:
> ERROR: Macros with complex values should be enclosed in parenthesis
> #10: FILE: ...
> +#define foo {a, b, c, d}
> 
> perhaps the check should also allow {...} ?  or ignore lists like this ...
> -mike

Ok, we can add that to the check.  Next update will allow that.

Thanks for the report.

-apw
