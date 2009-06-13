Return-Path: <linux-kernel-owner+w=401wt.eu-S1759679AbZFMX4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759679AbZFMX4a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 19:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbZFMX4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 19:56:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51182
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754245AbZFMX4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 19:56:21 -0400
Date: Sat, 13 Jun 2009 16:56:23 -0700 (PDT)
Message-Id: <20090613.165623.04217938.davem@davemloft.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       rostedt@goodmis.org
Subject: Re: [PATCH] Bring sparc64 dynamic ftrace up to snuff...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090613194027.GA25439@elte.hu>
References: <20090613.011020.214065340.davem@davemloft.net>
	<20090613194027.GA25439@elte.hu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 13 Jun 2009 21:40:27 +0200

> btw., just one (really stupid) question here: can ftrace_call be 
> misaligned, and is misalignment a problem on Sparc? If it's not a 
> problem then disregard the rest of the mail.

Every instruction must be 4-byte aligned on sparc.

Any instruction in the .text.* sections will thus always be 4-byte
aligned.
