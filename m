Return-Path: <linux-kernel-owner+w=401wt.eu-S1751467AbYIWJYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbYIWJYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 05:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbYIWJYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 05:24:03 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:4223 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbYIWJYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 05:24:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=RS4vh7D3nMUzGTk9qf7fwGG8t0Z+kzVz82VjlZJ4D/Cz7E+T3B0auRlKTY5YlMUfJY
         eiXKUmzu35/Cii0Grip2nMrcVOXuT1IAbxJCi/XZ2/a2SgliCzA/l41fcO5u9DYD+HXM
         Hs/UYh9DUvb+XdeDZ+rMPVLwJ9n3TQypaZXi8=
Message-ID: <48D8C516.4090706@gmail.com>
Date: Tue, 23 Sep 2008 11:29:42 +0100
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Steven Noonan <steven@uplinklabs.net>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [Patch -tip 0/4] Creation of the initcall tracer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is about the initcall tracer requested by Ingo Molnar.
It is supposed to replace the printk involved during fastboot if the initcall_debug parameter has been selected.

Currently this tracer is a test. Its output is not yet adapted for scripts/bootgraph.pl which uses the old initcalls printk to produce a graph. But since this tracer will output sched_switch and stack_trace, we should first talk about the future output format of this tracer in sync with bootgraph.pl

It currently not uses the sched_switch and stack_trace tracers since related functions of insertion into the ring buffer perhaps need first to be moved on their own tracer file. But it have to be discussed.

Note that you need the initcall_debug to enable this tracer. When printk from initcall_debug will disappear, we could surely enable this tracer by default without this parameter.

Old printk have been kept for backward compatibility.

Please don't hesitate to give any comment.

Thanks.

Frédéric Weisbecker.
