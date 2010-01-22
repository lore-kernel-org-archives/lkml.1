Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150Ab0AVJZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab0AVJZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 04:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104Ab0AVJZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 04:25:21 -0500
Received: from mail.gmx.net ([213.165.64.20]:55368 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752789Ab0AVJZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 04:25:19 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Oj2RgVvNOS0AnSI5bbM1c7HZh/ABlovoTCXjG/x
	XoKgp8ZFsJnDQv
Subject: Re: scheduler vs hardware? (was Re: another i7  (linux) bug?)
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Luca Zini <luca.zini@gmail.com>, aagaande@gmail.com, rdelcueto@hotmail.com,
       mingo@elte.hu, linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Chiang <achiang@hp.com>
In-Reply-To: <1264150272.4283.1361.camel@laptop>
References: <201001211258.23499.luca.zini@gmail.com>
	 <20100121215438.GK17684@ldl.fc.hp.com>
	 <1264144758.8074.22.camel@marge.simson.net>
	 <1264150272.4283.1361.camel@laptop>
Content-Type: text/plain
Date: Fri, 22 Jan 2010 10:25:14 +0100
Message-Id: <1264152314.12530.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.68000000000000005
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 09:51 +0100, Peter Zijlstra wrote:

> My laptop does:
> 
> 
> # time nice -n 19 lame -b 256 -V0 -h youcantdothat.wav - > /dev/null

> real    0m3.273s
> user    0m3.217s
> sys     0m0.022s
> 
> 
> # time nice -n 0 lame -b 256 -V0 -h youcantdothat.wav - > /dev/null

> real    0m1.121s
> user    0m1.102s
> sys     0m0.013s

I don't see any way that can be scheduler (knocks wood).  Could it be
cpufreq?  IIRC there is or was an ignore nice gizmo in there.

	-Mike 

