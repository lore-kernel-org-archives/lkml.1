Return-Path: <linux-kernel-owner+w=401wt.eu-S1752548AbXBDUnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbXBDUnJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 15:43:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbXBDUnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 15:43:09 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:40707 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbXBDUnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 15:43:08 -0500
Subject: Re: [PATCH -rt] Make RCU-boost and rcutorture threads freezable
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       dipankar@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       oleg@tv-sign.ru, twoerner.k@gmail.com, josh@freedesktop.org,
       billh@gnuppy.monkey.org, nielsen.esben@googlemail.com, corbet@lwn.net
In-Reply-To: <20070204042233.GA6645@linux.vnet.ibm.com>
References: <20070204042233.GA6645@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 05 Feb 2007 07:43:05 +1100
Message-Id: <1170621786.16991.10.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, 2007-02-03 at 20:22 -0800, Paul E. McKenney wrote:
> This patch removes PF_NOFREEZE from the rcutorture and RCU-boost threads,
> adding try_to_freeze() calls as required.  Passes the usual tests, but
> I don't have a good freeze test handy as yet.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Only a quick glance, but it looks great to me.

Thanks Paul!

Regards,

Nigel

