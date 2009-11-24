Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbZKXPpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbZKXPpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:45:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757363AbZKXPpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:45:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46126 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757477AbZKXPpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:45:15 -0500
Date: Tue, 24 Nov 2009 16:45:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Olsa <jolsa@redhat.com>
Cc: rostedt@goodmis.org, fweisbec@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: cannot compile linux-2.6-tip tree
Message-ID: <20091124154511.GG21821@elte.hu>
References: <20091124124107.GA1975@jolsa.lab.eng.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124124107.GA1975@jolsa.lab.eng.brq.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> drivers/pnp/card.o: file not recognized: File format not recognized
> make[1]: *** [drivers/pnp/built-in.o] Error 1

that typically happens if you Ctrl-C a parallel kernel build, and GCC 
leaves around an empty .o file.

It's rare but happens. 'make clean' will cure that.

	Ingo
