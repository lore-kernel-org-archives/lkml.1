Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbZFATCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbZFATCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 15:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbZFATCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 15:02:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39762 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752512AbZFATCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 15:02:42 -0400
Date: Mon, 1 Jun 2009 20:02:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: paul@mad-scientist.net
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] coredump: Retry writes where appropriate
Message-ID: <20090601200232.078aacbb@lxorguk.ukuu.org.uk>
In-Reply-To: <1243881544.8547.66.camel@psmith-ubeta.netezza.com>
References: <1243748019.7369.319.camel@homebase.localnet>
	<20090531111851.07eb1df3@lxorguk.ukuu.org.uk>
	<20090601161234.GA10486@redhat.com>
	<1243877766.8547.38.camel@psmith-ubeta.netezza.com>
	<20090601184934.1fc54411@lxorguk.ukuu.org.uk>
	<1243881544.8547.66.camel@psmith-ubeta.netezza.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If a program seems to be unresponsive the user could ^C, without
> realizing that it was really dumping core.  Now when they are asked to
> produce the core so the problem can be debugged, they can't do it.  Or,

and get their prompt back, which is probably why they are banging ^C. If
they didn't want their prompt back at that point they'd still be
wondering why nothing was occuring at the point it said (core dumped)

Alan
