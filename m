Return-Path: <linux-kernel-owner+w=401wt.eu-S1764356AbXESUhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764356AbXESUhK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 16:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759772AbXESUg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 16:36:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:50966 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758400AbXESUg6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 16:36:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=KKEQGpmMPs4Kedm1UZ52NJJog9N6rn8Bbfy9qSyBI/6v4w5ebg+EXLgw86H2SEuTwbODd2NiQ37g5CJaVVrNAaH1TcGKj8fiSFSZzDbesTFY+t9u8GyrxuAhB6i4gTyuuihro2xXuyVQZ+/24hRM76qYI3IBHhkaMCQZEp+TxsI=
Date: Sat, 19 May 2007 22:36:03 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
Message-Id: <20070519223603.8d70cd6e.diegocg@gmail.com>
In-Reply-To: <464F57DD.2000309@tmr.com>
References: <464F57DD.2000309@tmr.com>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.10.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Sat, 19 May 2007 16:02:37 -0400, Bill Davidsen <davidsen@tmr.com> escribió:

> The chart is at http://www.tmr.com/~davidsen/sched_smooth_01.html for 
> your viewing pleasure. The only "tuned" result was with sd, since what I 
> observed was so bad using the default settings. If any scheduler 
> developers would like me to try other tunings or new versions let me know.

How useful is glxgears as benchmark here? The X.org people has been saying
for ages that "glxgears is not a benchmark". Some people (at least on ubuntu)
even patched it so that if you want to get FPS numbers, you need to pass the
"-iacknowledgethatthistoolisnotabenchmark" option. There's a good page
explaining why at http://wiki.cchtml.com/index.php/Glxgears_is_not_a_Benchmark

I realize that it may be OK for scheduler testing, but maybe it'd be more
interesting to test other kind of 3d benchmark tools.
