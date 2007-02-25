Return-Path: <linux-kernel-owner+w=401wt.eu-S964955AbXBYPpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964955AbXBYPpU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 10:45:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964968AbXBYPpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 10:45:20 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:39896 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964955AbXBYPpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 10:45:19 -0500
Message-ID: <45E1AEFF.5050202@student.ltu.se>
Date: Sun, 25 Feb 2007 16:45:03 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Milind Arun Choudhary <milindchoudhary@gmail.com>
CC: Vojtech Pavlik <vojtech@suse.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz
Subject: Re: [KJ][RFC][PATCH] BIT macro cleanup
References: <45DEF5EE.4030002@student.ltu.se> <d120d5000702230657s1860efb3o6986277901f13d03@mail.gmail.com> <45DF1165.2080003@student.ltu.se> <d120d5000702230905r6b50a1bbm3b71551f855cdf01@mail.gmail.com> <45DF2F57.2080309@student.ltu.se> <d120d5000702231037q511f8073n47beed320f097458@mail.gmail.com> <45DF3C53.4030100@student.ltu.se> <d120d5000702231358j55cd6665x2add335ceb904c22@mail.gmail.com> <45DF6E20.9060604@student.ltu.se> <20070224111124.GB3609@suse.cz> <20070224191001.GA9547@arun.site>
In-Reply-To: <20070224191001.GA9547@arun.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Milind Arun Choudhary wrote:
> why bitops.h? coz BIT qualifies for a "bitop" 
> & bitops.h is  inclued by kernel.h, hence accessible from every part 
> of the tree without mucb efforts
>   
I don't think there is anyone who objects to this
> c>but it is not sutaible for  those who want to go beyond this limit, 
> as they will not be warned 
>   
And this is the reason for this overly long thread :)
> So all we need is  people to be carefull  before passing anything to BIT
>   
This is the difficult thing to do
> so  now i think it should be ok to have
>
> #define BIT(nr) (1UL << ((nr) % BITS_PER_LONG))
> #define LLBIT(nr) (1ULL << (nr))
>
>
> thoughts
>   
Since you guys seems in agreement about the silenced compiler-warnings, 
then I will rest my case.

Richard Knutsson

