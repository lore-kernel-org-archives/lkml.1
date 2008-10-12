Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbYJLL37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbYJLL37 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 07:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYJLL3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 07:29:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:36589 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbYJLL3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 07:29:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kebfr6GMJ5A3RMdPIvOL0NoN1aEdGV1lMz30AcVt4GKLpkHJspffHE3CX6tOJaq1sK
         VT/XRVVVrOWYqvmE8XQLEr0GRrdR25hBeDFYkiY/dC1hkieXpCPe82lBCEazhtJl3R3g
         b4qMrmojVwpmI7YplewDeuqv5EcidqZzDPT3M=
Message-ID: <c62985530810120429u774c7eefm44bef7d8b4199115@mail.gmail.com>
Date: Sun, 12 Oct 2008 13:29:48 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 4/5] tracing/fastboot: Add a time field on the sched_switch entry
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Arjan van de Ven" <arjan@linux.intel.com>
In-Reply-To: <alpine.DEB.1.10.0810111947120.19507@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48F10A9D.3030705@gmail.com>
	 <alpine.DEB.1.10.0810111644440.19507@gandalf.stny.rr.com>
	 <c62985530810111358o10e33becw8ce9c83c46733f3b@mail.gmail.com>
	 <alpine.DEB.1.10.0810111947120.19507@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/12 Steven Rostedt <rostedt@goodmis.org>:
> You can tap into the context switch trace_point too, and have that record
> a special trace entry for you instead.


That's what I did first.
See ctx_switch_boot_entry on this patch: http://lkml.org/lkml/2008/10/10/194
But Ingo suggested that it would be better to add a the time field on
the usual ctx entry.

I don't know....
