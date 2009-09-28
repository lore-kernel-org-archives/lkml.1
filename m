Return-Path: <linux-kernel-owner+w=401wt.eu-S1752370AbZI1Ihv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbZI1Ihv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 04:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbZI1Ihv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 04:37:51 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:45126 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbZI1Ihu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 04:37:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=wjpY+Yu4MdW6AAVpkND8NNxERIb90WhQMd0uhUktNaUm+7Ubi7Ee8bJr3m5V6dz8bx
         41MrW0dhoJR5l79bmIWgO55La4OOQczbqgGdU8aIiZyg2HZM1E0FYYdlRU0Vw/AjsW32
         E/sGp5YpHKJotb1ipvKvYMSEZ7z5xms6dR3+Q=
MIME-Version: 1.0
In-Reply-To: <20090928075540.GD6668@linux-sh.org>
References: <20090928075540.GD6668@linux-sh.org>
Date: Mon, 28 Sep 2009 11:37:52 +0300
X-Google-Sender-Auth: e35c6b2832379842
Message-ID: <84144f020909280137n6126eb7bm39a32dd7258694d@mail.gmail.com>
Subject: Re: [PATCH] kmemtrace: Fix up tracer registration.
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Paul Mundt <lethal@linux-sh.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 10:55 AM, Paul Mundt <lethal@linux-sh.org> wrote:
> Commit ddc1637af217dbd8bc51f30e6d24e84476a869a6
> ("kmemtrace: Print binary output only if 'bin' option is set") ended up
> inverting the error detection logic. register_tracer() returns 0 on
> success, which this change caused to treat as an error, resulting in:
>
> [    0.132000] Warning: could not register the kmem tracer
>
> as well as bailing out of the initcall with an error value. This
> restores the old logic.
>
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

Looks good to me. Thanks Paul!

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
