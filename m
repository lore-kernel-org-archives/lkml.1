Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbYLMP24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbYLMP24 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 10:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbYLMP2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 10:28:48 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:62239 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbYLMP2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 10:28:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=l7eRAA74RVI4bWa1ITEPJKvSMlgFih2fqbiTa1Et49Yts+7bvX4AuBdhmylZOa6QSs
         XBwQi7+wc7QvAMHOyTXpfQ9hvI4mtolaeu2g4XQLAHVaYYEScOr9+YSOIi7Bm6DcFvWF
         Jwk4Z7ecU/3KvleffG7p9i4xsBR7igbFbvZFA=
Message-ID: <c62985530812130728w12230974u1a19d674b429a3e3@mail.gmail.com>
Date: Sat, 13 Dec 2008 16:28:45 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [RFC] x86: entry_64 - introduce FTRACE_ frame macro
Cc: "Cyrill Gorcunov" <gorcunov@gmail.com>,
       "Steven Rostedt" <srostedt@redhat.com>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Alexander van Heukelum" <heukelum@fastmail.fm>
In-Reply-To: <alpine.DEB.1.10.0812130956350.17344@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081212184136.GB14192@localhost>
	 <20081212204724.GA26194@localhost>
	 <alpine.DEB.1.10.0812121552360.19351@gandalf.stny.rr.com>
	 <20081212205729.GA28554@localhost>
	 <alpine.DEB.1.10.0812121620520.19351@gandalf.stny.rr.com>
	 <20081212213538.GA731@localhost>
	 <alpine.DEB.1.10.0812121655090.19351@gandalf.stny.rr.com>
	 <20081213082054.GA7559@localhost>
	 <c62985530812130646r6bcdf424o752f16458dd22914@mail.gmail.com>
	 <alpine.DEB.1.10.0812130956350.17344@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/13 Steven Rostedt <rostedt@goodmis.org>:
> It could be, but remember, the dynamic ftrace gives the ability to specify
> which function can be chosen.
>
> But on the other hand, I guess it would be fine to have it separate. There
> is no reason that it can not be. I would still keep the dynamic part
> dependent on function tracer. At least for now.
>
> -- Steve

I agree. I don't think it will require much modifications.
I think I will change it for 2.6.30....
