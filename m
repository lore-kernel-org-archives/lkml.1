Return-Path: <linux-kernel-owner+w=401wt.eu-S933815AbXEVL0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933815AbXEVL0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 07:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755748AbXEVL0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 07:26:42 -0400
Received: from web52606.mail.re2.yahoo.com ([206.190.48.209]:27592 "HELO
	web52606.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755701AbXEVL0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 07:26:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=06ucUcfXGdWgsOpXu7833ci45c9cfa8xXwrRdVR7/NyNLqdMdB1oBNSbORZCSlqOkMc4ZPSgBZffLqlL+5aE2WR/J3e0gJkwQOePwGx4ut+cJc6yDxz/PQfEK2ZIEFNV7xIvISgm9gFrqlIX5pop2kfUJrYiM+OGLSN91MMXWyw=;
X-YMail-OSG: QEuruIIVM1lOdKrQAXmJ2DmwF4PrW8ZaD3IBQVHUwAM2kf3cRgFcU3joRTcHTE1C_A--
Date: Tue, 22 May 2007 21:26:40 +1000 (EST)
From: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>, Hugh Dickins <hugh@veritas.com>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070522112008.GA16308@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <441137.33501.qm@web52606.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Ingo Molnar <mingo@elte.hu> wrote:
[...]
> yes - PROVE_LOCKING reactivates spinlocks even on UP. At least this 
> suggests that you'd have gotten the hang even with maxcpus=1 - i.e. the 
> spinlock corruption is not caused by some genuine SMP race.
 
You're right on the mark there: even with maxcpus=1 or nosmp (or with both),
with PROVE_LOCKING it hung with slub. I didn't mention that so not to confuse
the matter, but you rightly figured that out too.

Thanks



      ___________________________________________________________________________________
How would you spend $50,000 to create a more sustainable environment in Australia?  Go to Yahoo!7 Answers and share your idea.
http://advision.webevents.yahoo.com/aunz/lifestyle/answers/y7ans-babp_reg.html

