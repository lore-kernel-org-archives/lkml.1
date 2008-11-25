Return-Path: <linux-kernel-owner+w=401wt.eu-S1752516AbYKYPTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbYKYPTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbYKYPTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:19:00 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:38304 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbYKYPS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:18:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=awigLzWls5lP0PagaHAhnvsJHi1jNij0Lc41lwIZPnZsyBCAl0+c7jn9wVi1tHm/S6
         L+QyNIaWg5ylVKNUClqo7z9+VwrMvKE2jEYHTk32mky4VnpcQRt9nb56BSDr+OQpb4r5
         t8CbXB3EqY57ZCSQrzxTWeuM9xWFWYU3ddwFc=
Message-ID: <c62985530811250718q3aa5f2ednd795b7c927abb8e4@mail.gmail.com>
Date: Tue, 25 Nov 2008 16:18:57 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Human readable output for function return tracer
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081124162719.GA11532@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c62985530811240639w574659c0nd0a54e6c1fb1197a@mail.gmail.com>
	 <20081124162719.GA11532@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I made a patch last evening and I almost finished implementing the
desired output.
But while I went through, I was adding some more keywords with other
"return-function-tracing" semantics, plus the risk of confusion
resulting from the entry-on-function-for-return-tracing keywords....

I planned to change all the keywords according to a new name for this
tracer just after this patch.
But I can't seriously submit such a mess, even with a second patch
that fixes the keywords....

I would like to change the name of the tracer and its keywords before
sending the output changes.
Do you agree with "full function tracer" (since we hook now on the two sides)?

Thanks.... :-)
