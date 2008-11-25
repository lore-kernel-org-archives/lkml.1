Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbYKYIzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbYKYIzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 03:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbYKYIzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 03:55:23 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:1645 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYKYIzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 03:55:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eALgwrkhmjsl+AwX0ckCBKi6ak5GkeYdpmjHnQKkd42I3IETTJNSMAulvPJ0H4/otw
         pJ+T2viaco/p7zBK3KBCMZASVy1y+Z2oMnzTTXy7ro1Av8QIsrR+U1vRxohDv2Z/MLIJ
         bFisNNxyWVQSO9MZY/+3y+KjnjhjVle6Xjh9Q=
Message-ID: <c62985530811250055m9692087ncf7a9ef3e3250f21@mail.gmail.com>
Date: Tue, 25 Nov 2008 09:55:21 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Markus Metzger" <markus.t.metzger@intel.com>
Subject: Re: [patch 8/9] x86, ftrace: call trace->open() before stopping tracing; add trace->print_header()
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       eranian@googlemail.com, juan.villacis@intel.com
In-Reply-To: <20081125091231.A31411@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081125091231.A31411@sedona.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/25 Markus Metzger <markus.t.metzger@intel.com>:
> Add a callback to allow an ftrace plug-in to write its own header.


That's a good idea IMHO. The trace file has always the same header
which fits the needs of function
tracer for example, but these headers are wrong for other tracers. And
be able to set custom header
for each one will help for new users of a tracer.
