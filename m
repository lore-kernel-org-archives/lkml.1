Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbYLOQqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbYLOQqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 11:46:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756309AbYLOQps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 11:45:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:45482 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282AbYLOQpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 11:45:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=GvUsKkqn6B8VQPwQQhE+MT1q1PSuFrKI+49WodxLVxsWz1kz+9VHEMThPqB+DaTyVZ
         73XwSovURef6Pnu7TmOaKAmb+g4IttiGnh+x/ds4kNu/sjOUfzxJPPihte7RibgrEKIP
         Zdj6pvzz4fRzX7yP3aYgF8BFjNFwEXXgT9HEE=
Message-ID: <84144f020812150845g10a1ce26ke2844ab495d2591b@mail.gmail.com>
Date: Mon, 15 Dec 2008 18:45:44 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ottavio Campana" <ottavio.campana@dei.unipd.it>
Subject: Re: Oops when trying to create more than 16000 timers
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <49468024.1020700@dei.unipd.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49468024.1020700@dei.unipd.it>
X-Google-Sender-Auth: b0712e6afec1b328
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ottavio,

On Mon, Dec 15, 2008 at 6:04 PM, Ottavio Campana
<ottavio.campana@dei.unipd.it> wrote:
> I am currently developing a software that needs approx 60k timers. I
> currently use timer_create and all the relative functions to manage timers.
>
> I've noticed that after having created 16039 timers I always get an oops
> from the kernel, which are always of the same kind:
>
> Dec 15 15:20:00 evolution kernel: [601680.417064] BUG: unable to handle
> kernel NULL pointer dereference at 0000000000000040 .

This would be a kernel bug so can you please post the full oops. See
REPORTING-BUGS and Documentation/oops-tracing.txt for details.
