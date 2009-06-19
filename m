Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbZFSXEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbZFSXEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 19:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZFSXEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 19:04:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42046
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751948AbZFSXEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 19:04:25 -0400
Date: Fri, 19 Jun 2009 16:04:29 -0700 (PDT)
Message-Id: <20090619.160429.52033928.davem@davemloft.net>
To: rientjes@google.com
Cc: ebiederm@xmission.com, eric.dumazet@gmail.com, jpiszcz@lucidpixels.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] ipv4: don't warn about skb ack allocation failures
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.00.0906191524470.30455@chino.kir.corp.google.com>
References: <20090618.123708.78849607.davem@davemloft.net>
	<m1ljnoyn0e.fsf@fess.ebiederm.org>
	<alpine.DEB.2.00.0906191524470.30455@chino.kir.corp.google.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>
Date: Fri, 19 Jun 2009 15:37:17 -0700 (PDT)

> That was possible because of the page allocation failure messages that 
> were noticed by the user; without this evidence, the only symptom would 
> have been extremely slow I/O over nfs.

That's garbage.

With tracing and statistics you could have noticed it too.

Just because the notification is more annoying and in your
face, does not mean it's implicitly better.
