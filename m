Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbYJIKXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbYJIKXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 06:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbYJIKXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 06:23:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:45146 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbYJIKXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 06:23:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WkbzQNR9teiIaVtvxNQzGI5d6PZD6LMr7ElUXaNpSjl2uj6ry42zV2bWvrB7zOs/qA
         o/OFu0g2oLxGoX6hSZSyL4chld+YectsS3WHVbaJPGr7JcaWP/iDXX/26L6+3zK4ReLN
         6naYOJKbV/JhfxKeFjeVyYaQmra4YaMvI4n6U=
Message-ID: <c62985530810090323vd5d08e0haa618ca0cbe0c73f@mail.gmail.com>
Date: Thu, 9 Oct 2008 12:23:13 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] rudimentary tracing for Classic RCU
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rjw@sisk.pl,
       dipankar@in.ibm.com, tglx@linuxtronix.de, andi@firstfloor.org
In-Reply-To: <20081009010846.GA10188@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081006141220.GA14160@basil.nowhere.org>
	 <20081006232837.GA1157@basil.nowhere.org>
	 <20081007030822.GC6820@linux.vnet.ibm.com>
	 <20081007071544.GC20740@one.firstfloor.org>
	 <20081007152629.GH6384@linux.vnet.ibm.com>
	 <20081007154939.GN20740@one.firstfloor.org>
	 <20081007163401.GJ6384@linux.vnet.ibm.com>
	 <20081007210947.GP20740@one.firstfloor.org>
	 <20081007212215.GN6384@linux.vnet.ibm.com>
	 <20081009010846.GA10188@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/9 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> Hello!
>
> This is a tracing patch for Classic RCU, which creates an "rcu/rcucb"
> file in debugfs.  This patch can be handy when you need to work out
> why RCU is refusing to end the current grace period.
>
> Reading from the file results in something like the following:
>
>        rcu: cur=1129  completed=1128  np=0  s=0
>                0,3,7
>        rcu_bh: cur=-287  completed=-287  np=0  s=0
>
>        online: 0-7


Hi Paul,

Why don't you use the ring-buffer tracing engine?
You will really make your life better by putting it as a tracer in
kernel/trace and by using the relevant API.
That will avoid you to manage the debugfs things, the memory
allocation, the buffer managment.....
