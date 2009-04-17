Return-Path: <linux-kernel-owner+w=401wt.eu-S1761284AbZDQRZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761284AbZDQRZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 13:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758390AbZDQRZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 13:25:47 -0400
Received: from gw.goop.org ([64.81.55.164]:56556 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759025AbZDQRZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 13:25:46 -0400
Message-ID: <49E8BB98.3090901@goop.org>
Date: Fri, 17 Apr 2009 10:25:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] tracing/lockdep: turn lock->name into an array
References: <1239662166-13208-1-git-send-email-fweisbec@gmail.com> <20090414153035.C662.A69D9226@jp.fujitsu.com> <20090414065303.GA24626@elte.hu>
In-Reply-To: <20090414065303.GA24626@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> We could zap all pending trace entries on module unload (it is a 
> rare operation)

...Unless you're trying to trace something across a module unload.  I 
don't know if its at all practical, but it would be nice to just zap the 
pointers within the buffer, rather than the whole buffer.

    J
