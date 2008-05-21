Return-Path: <linux-kernel-owner+w=401wt.eu-S1764756AbYEUOpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764756AbYEUOpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 10:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbYEUOpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 10:45:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41618 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754114AbYEUOpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 10:45:45 -0400
Date: Wed, 21 May 2008 09:48:40 -0500
From: Cliff Wickman <cpw@sgi.com>
To: dmitry.adamushko@gmail.com, avi@qumranet.com, mingo@elte.hu,
       heiko.carstens@de.ibm.com, a.p.zijlstra@chello.nl,
       vatsa@linux.vnet.ibm.com
Cc: Avi Kivity <avi@qumranet.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       PeterZijlst@sgi.com
Subject: [BUG] hotplug cpus on ia64
Message-ID: <20080521144840.GA32628@sgi.com>
References: <4829A6A0.5040208@qumranet.com> <b647ffbd0805140113i4296076cna3f371c86c479653@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0805140113i4296076cna3f371c86c479653@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gentlemen,

  I built an ia64 kernel from Andrew's tree (2.6.26-rc2-mm1)
and get a very predictable hotplug cpu problem.

billberry1:/tmp/cpw # ./dis
disabled cpu 17
enabled cpu 17
billberry1:/tmp/cpw # ./dis
disabled cpu 17
enabled cpu 17
billberry1:/tmp/cpw # ./dis

The script that disables the cpu always hangs (unkillable)
on the 3rd attempt.
I haven't spent any debugging time on it yet.

Just wondering if you've seen it?   It doesn't seem to happen x86_64.

-Cliff Wickman
cpw@sgi.com
