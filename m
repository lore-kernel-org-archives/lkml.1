Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab0BLEN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 23:13:57 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:57355 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764Ab0BLEN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 23:13:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fNQDL6Fy1KA2UllZOZ1VImodRsxuP/Ut3G2ZSh+VD/T2lN9/raWxTglrt2XZtBHolx
         8ZjnCaRxlsZBtGvpCAIEkS7R6cP8OJretKBRjy75LtfJ5wNe/Qv6ZZ3aqW+6b390pavh
         kJ9TtuIhxpx7hUiEe9dFsgRoBJbGkVGj78O9g=
Subject: Re: [PATCH tip/core/rcu 02/13] rcu: add lockdep-enabled variants
 of rcu_dereference()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com
In-Reply-To: <1265932839-25899-2-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20100212000016.GA25781@linux.vnet.ibm.com>
	 <1265932839-25899-2-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Feb 2010 05:13:51 +0100
Message-ID: <1265948031.2891.22.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 11 février 2010 à 16:00 -0800, Paul E. McKenney a écrit :
> Make rcu_dereference() check for being in an RCU read-side critical
> section, and create rcu_dereference_bh(), rcu_dereference_sched(), and
> srcu_dereference() to check for the other flavors of RCU.  Also create
> rcu_dereference_raw() to avoid checking, and make rcu_dereference_check()
> use rcu_dereference_raw().
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>



