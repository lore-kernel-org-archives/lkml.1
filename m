Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbZERU4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbZERU4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 16:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbZERU4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 16:56:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:33212 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbZERU4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 16:56:14 -0400
In-Reply-To: <1242620044.18075.31.camel@pasglop>
References: <20090502001329.GA11549@oksana.dev.rtsoft.ru> <20090502001421.GA9342@oksana.dev.rtsoft.ru> <68B2EF73-0FD2-41F9-966B-9A54965AFBA6@kernel.crashing.org> <1241316249.4243.22.camel@localhost.localdomain> <6A6BE346-925C-4F73-ABFA-C6110070F071@kernel.crashing.org> <1241530382.11379.12.camel@localhost.localdomain> <299D7402-29D3-4602-8F42-58FDF034DEC5@kernel.crashing.org> <1241565080.11379.14.camel@localhost.localdomain> <1242620044.18075.31.camel@pasglop>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <7171D9FE-B5DD-40B7-B7F2-BFD5694B398B@kernel.crashing.org>
Cc: Steven Rostedt <srostedt@redhat.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Sam Ravnborg <sam@ravnborg.org>
Content-Transfer-Encoding: 7bit
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 1/3] powerpc, Makefile: Make it possible to safely select CONFIG_FRAME_POINTER
Date: Mon, 18 May 2009 21:55:59 +0200
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Segher, what are we missing here ?

The symbol name is misleading, and the help text is incorrect.

With those things fixed, I won't oppose the patch; it would
be nice if the logic here was cleaned up to avoid all the
double negations, but I'm not going to do it, so I won't ask
others to either.


Segher

