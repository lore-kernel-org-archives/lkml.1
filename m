Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbXG1UwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbXG1UwX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 16:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbXG1UwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 16:52:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:44912 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003AbXG1UwA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 16:52:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=rUNh/OJhqS1svOaTrlRl1vWGbkjS2NCfPCNf82SFfslkEgNqSBkn8DNT69h88s0DT1dK5UAegWzMtKReU7491xKV0kPGDuW8NAGu7FsrLUyjDwkNFt/01+Lt0gmbAo4xhV7f+KEgqkXJva2ut0Q0141dSIwC3oiUTAYq3bsoQ2w=
Date: Sat, 28 Jul 2007 22:51:48 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Jonathan Jessup <jonathanjessup@gmail.com>,
       Grzegorz Kulewski <kangur@polcom.net>, linux-kernel@vger.kernel.org,
       ck@vds.kolivas.org, lkml@metanurb.dk
Subject: Re: [ck] Re: Linus 2.6.23-rc1
Message-Id: <20070728225148.a0e58fdd.diegocg@gmail.com>
In-Reply-To: <alpine.LFD.0.999.0707281050590.3442@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	<1185588279.1654.1.camel@localhost>
	<alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
	<Pine.LNX.4.63.0707280817540.27758@alpha.polcom.net>
	<954c7c800707280045t4607cebfj532ef025a7a57c05@mail.gmail.com>
	<alpine.LFD.0.999.0707280956140.3442@woody.linux-foundation.org>
	<Pine.LNX.4.64.0707281927500.15125@fbirervta.pbzchgretzou.qr>
	<alpine.LFD.0.999.0707281050590.3442@woody.linux-foundation.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Sat, 28 Jul 2007 11:05:25 -0700 (PDT), Linus Torvalds <torvalds@linux-foundation.org> escribió:

> So "modal" things are good for fixing behaviour in the short run. But they 
> are a total disaster in the long run, and even in the short run they tend 
> to have problems (simply because there will be cases that straddle the 
> line, and show some of _both_ issues, and now *neither* mode is the right 
> one)


I fully agree with this, but plugsched could have avoided this useless "division"
on the topic of SD vs CFS. IMO that counts as an advantage, too ;)
