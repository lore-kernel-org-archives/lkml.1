Return-Path: <linux-kernel-owner+w=401wt.eu-S1765361AbXHFVKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765361AbXHFVKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 17:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761754AbXHFVKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 17:10:32 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:54977 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760498AbXHFVKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 17:10:31 -0400
Date: Mon, 6 Aug 2007 18:10:23 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: convert mm_context_t semaphore to a mutex
Message-ID: <20070806181023.13b5aba3@localhost>
In-Reply-To: <20070806103655.4428c5d2@localhost>
References: <20070803105540.4f85ae09@localhost>
	<20070806074608.GA12415@elte.hu>
	<20070806103655.4428c5d2@localhost>
Organization: Mandriva
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 6 Aug 2007 10:36:55 -0300
"Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br> escreveu:

| Em Mon, 6 Aug 2007 09:46:08 +0200
| Ingo Molnar <mingo@elte.hu> escreveu:
| 
| | 
| | >  typedef struct { 
| | >  	int size;
| | > -	struct semaphore sem;
| | > +	struct mutex lock;
| | 
| | hm, looks good to me but i'm wondering why this was a holdout for such a 
| | long time :-) Did you manage to test actual LDT functionality with this 
| | patch applied?
| 
|  No, I didn't. The only test I did was to run the kernel with this
| patch applied.
| 
|  I'll manage to test it then. Do you have a test-case or has any
| suggestion?

 And again, SMTP problems makes me looks like a joker...

 Sorry for the spam, just realized the problem now.

-- 
Luiz Fernando N. Capitulino
