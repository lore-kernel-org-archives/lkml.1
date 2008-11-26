Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbYKZNW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbYKZNW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYKZNWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 08:22:20 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:51310 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbYKZNWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 08:22:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qok4V1ynqtVqlE7tX5yHzZCUc9z6jAJAztO6fICsYQ52Xi6txoZl7B3y70m6meaTQg
         6aUBv6+EQ7YX55LZtePXj2KhHesgTL0NY6/LNuPt6WFZS3Y6bAn8sG4s300TPbdQ3i7m
         fYMpzq2Y1RGg48oJY5nTTkTlqL98CBFTemTmI=
Message-ID: <c62985530811260522s359bd466j83cc99050d5a304a@mail.gmail.com>
Date: Wed, 26 Nov 2008 14:22:17 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing/function-return-tracer: set a more human readable output
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811260718570.26424@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492C90E5.8070907@gmail.com> <20081126003936.GA26937@elte.hu>
	 <20081126020459.GA16374@elte.hu>
	 <alpine.DEB.1.10.0811252113270.26424@gandalf.stny.rr.com>
	 <c62985530811260332m20a3388dy7bdc1fc15811898d@mail.gmail.com>
	 <alpine.DEB.1.10.0811260718570.26424@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/26 Steven Rostedt <rostedt@goodmis.org>:
> I'd suggest just looking at how those are implemented, and use your own.
> One note, the latency tracer looks at the next entry, even if it is on
> another CPU. This is incorrect, and will definitely be incorrect for you.
> Just use the ring_buffer_iter_peek, that will get you what you want. Well,
> for leaf functions.
>
> -- Steve
>
>


Ok, thanks for your tips!
