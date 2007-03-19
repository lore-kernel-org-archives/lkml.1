Return-Path: <linux-kernel-owner+w=401wt.eu-S932468AbXCSPKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbXCSPKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 11:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932446AbXCSPKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 11:10:01 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:39115 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469AbXCSPKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 11:10:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=KGtQWsJCjlVSQIn6jyH+b0HWiU0fRaLpenvW/56sBi0O1iw2edrP2ZgZLpmwIGrY7JrcoyospWtrwXGKsg7wJfo/SaBkPIZvzKgvDYbg8jXu+sHGqcJ6XI0u6WJAi0lF+3+in7sPx35cmd4DWEWI8eiQ+RfupYhVIBL0EFvxxOw=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][0/5][resend] floppy.c: first round of cleanup patches - the simple stuff
Date: Mon, 19 Mar 2007 16:09:45 +0100
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Trent Waddington <trent.waddington@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703191609.47146.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings people,

A while back I promised to do some floppy.c cleanups and created an initial 
set of patches. Those patches got some good feedback but never got merged.
I want to continue with more substantial cleanups, but it would be nice to get 
the initial (rather trivial) bits in first so I can submit further patches on 
top.

I've been using these patches myself without any problems and they have also 
been Ack'ed by a few people;
	Alan Cox said:
		"Acked-by: Alan Cox <alan@redhat.com>
		 for the set of 5 patches. Its a beginning and removing the dead wood so
		 you can see what is actually there is a good a beginning as any other."
	Bartlomiej Zolnierkiewicz said:
		"Seconded, looks like a good beginning.
		 You may also add my ACK for the whole set."

Andi Kleen commented that the real problem with floppy.c is the basic code 
logic and that most of the code I'm fixing up here probably has to be 
replaced later anyway - there's no doubt that's correct, but I need to start 
somewhere and starting with these small patches makes the file a lot easier 
for me to work with and I think they are a nice little initial cleanup until 
I get a chance to do something more substantial (which probably won't be for 
another month and a half since I'm currently without internet connectivity at 
home).


There are 5 patches in this series. They are based on current Linus -git and 
are incremental.

These are the patches (they'll be posted to the same recipients as this 
mail) :

       [PATCH][1/5][resend] floppy.c: Initial (partial) CodingStyle cleanup
       [PATCH][2/5][resend] floppy.c: Remove pointless register keywords
       [PATCH][3/5][resend] floppy.c: Remove dead/commented out code
       [PATCH][4/5][resend] floppy.c: Add explicit/better printk() levels
       [PATCH][5/5][resend] floppy.c: Fix device_create_file() warning

The Cc list is composed of people who expressed interrest in this cleanup +
people who look like original authors of the code (for whom I could locate
email addresses) etc.

Andrew: Could you please merge these into -mm? And if you could push them to 
Linus after a bit of time in -mm that would be greatly appreciated as well.


Kind regards,

 Jesper Juhl <jesper.juhl@gmail.com>


