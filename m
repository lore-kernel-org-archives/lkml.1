Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbYJMIKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbYJMIKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 04:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbYJMIKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 04:10:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:51522 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbYJMIKo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 04:10:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GQgrGZPUb+qca3V0dA6o2Gn2VTwV/U2Ob58AQJ6noWuzq09jwZtxPiioqjt7qtL/Au
         lM+AhSnEydVK+KFPFBaxRRLaYhSLthSLsrudjku9TLgMqFCKtqKy4i+Q1RQ83c98k+7/
         BUWzWAytqrANjSyaaYCha+n88Sc1iH2lemDVE=
Message-ID: <c62985530810130110r5ba73d04wec70e597abd48126@mail.gmail.com>
Date: Mon, 13 Oct 2008 10:10:42 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 4/5] tracing/fastboot: Add a time field on the sched_switch entry
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Arjan van de Ven" <arjan@linux.intel.com>
In-Reply-To: <c62985530810120429u774c7eefm44bef7d8b4199115@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <48F10A9D.3030705@gmail.com>
	 <alpine.DEB.1.10.0810111644440.19507@gandalf.stny.rr.com>
	 <c62985530810111358o10e33becw8ce9c83c46733f3b@mail.gmail.com>
	 <alpine.DEB.1.10.0810111947120.19507@gandalf.stny.rr.com>
	 <c62985530810120429u774c7eefm44bef7d8b4199115@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/12 Frédéric Weisbecker <fweisbec@gmail.com>:
> 2008/10/12 Steven Rostedt <rostedt@goodmis.org>:
>> You can tap into the context switch trace_point too, and have that record
>> a special trace entry for you instead.

Another thing I could do: when a sched switch entry occurs, I could
send a special timestamp entry that
fits my needs just before the commit of the sched entry, only if the
current tracer is the boot tracer. This way I can output
the appropriate timestamp just before output the sched entry.

What do you think?
