Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbZKPWPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbZKPWPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbZKPWPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:15:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53681 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbZKPWPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:15:54 -0500
Subject: Re: [PATCH] ftrace: fix trace_marker output
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Carsten Emde <Carsten.Emde@osadl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4B01AE5D.1010801@osadl.org>
References: <4B01AE5D.1010801@osadl.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 16 Nov 2009 17:15:57 -0500
Message-Id: <1258409757.22249.457.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-16 at 20:56 +0100, Carsten Emde wrote:
> When a string was written to <debugfs>/tracing/trace_marker, some
> strange characters appeared in the trace output instead of the
> string, since a vprint function erroneously called a vararg print
> function with a va_list argument. This patch fixes the problem and
> simplifies the related code.
> 
> Signed-off-by: Carsten Emde <C.Emde@osadl.org>

Thanks Carsten! I'll pull this in. Perhaps this should go into 32.

-- Steve



