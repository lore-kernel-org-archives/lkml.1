Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbXJIMky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbXJIMky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 08:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbXJIMkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 08:40:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:56849 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbXJIMkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 08:40:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=cMJTBe7r0KHS+BCvmS2rdlcRWehZJ2WE3YRTmbi5RIY5MLLB8J8hgeaxg0LQs7MFAbxGXMoeKScRyal/EpRnRefrR9Q2ydtH+xZ0mfdrznFOo8b3QsQClrv/cq1iMteswpk3w2ERR59/KJZ82LlfMQ45JcjHzJk9XfOmC3+cOlI=
Date: Tue, 9 Oct 2007 14:40:35 +0200
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: aia21@cantab.net, linux-ntfs-dev@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NTFS error messages: replace static char pointers by static char arrays
Message-ID: <20071009124035.GA4245@Ahmed>
References: <470AA75E.7010508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470AA75E.7010508@gmail.com>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 01:55:42AM +0400, Dmitri Vorobiev wrote:
> Hi,
> 
> The patch below contains a small code clean-up for the NTFS driver: all
> static char pointers to error message strings have been replaced by 
> static char arrays.
> 

Hi Dmitri,

Isn't the only difference between char *c = "msg" and char c[] = "msg" is 
that the first is a non-const pointer to a const char array while the second 
is a modifiable char array ?

If so, what's the point of the patch ?

Thanks,

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
