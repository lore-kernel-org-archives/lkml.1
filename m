Return-Path: <linux-kernel-owner+w=401wt.eu-S1760271AbYJKUFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760271AbYJKUFX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 16:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758333AbYJKUFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 16:05:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:2935 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758014AbYJKUFB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 16:05:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PuuaZFMCCISfiYgKiF44EfY4CS+UV7NN0+DqKH+Xgb5ncWl+JIZIQZnbGyXO9J0YvD
         QacY3CMXqQgFkaKiO3hfc7GPXyYWjBCmlDZxOF4SfM+LCc1cqGRywRi73dLm1BSu6KiY
         5DaHWEJ+uT2r4VrjrnxrdMoGopjTvlSJDUjpc=
Message-ID: <c62985530810111304jfb4fb65q2d8a55f3cb71ca87@mail.gmail.com>
Date: Sat, 11 Oct 2008 22:04:59 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 6/6] tracing/fastboot: Print ktime of sched events when boot tracing
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <c62985530810111303h2ac6e02ewf54765717895c949@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20081010123450.8D3E6D1BCF0@perso1.free.fr>
	 <20081010140534.GB13137@elte.hu> <20081010194530.GA31401@elte.hu>
	 <c62985530810111303h2ac6e02ewf54765717895c949@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/11 Frédéric Weisbecker <fweisbec@gmail.com>:
>
> ....I guess that could happen when the boot tracer is configured
> whithout the sched_switch tracer.
> I will send a patch to add this dependance on the Kconfig...
>
> Thanks.
>

Oh I didn't see that you attached the config.
Seems that it's what I thought:

# CONFIG_SCHED_TRACER is not set
