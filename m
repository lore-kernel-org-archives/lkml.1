Return-Path: <linux-kernel-owner+w=401wt.eu-S1755619AbZJ0AdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbZJ0AdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 20:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbZJ0AdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 20:33:20 -0400
Received: from smtp-out.neti.ee ([194.126.126.34]:37666 "EHLO smtp-out.neti.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567AbZJ0AdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 20:33:20 -0400
X-SMTP-Auth-NETI-Businesmail: no
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 2] Two small UI tweaks to perf
Message-Id: <patchbomb.1256603583@localhost>
User-Agent: Mercurial-patchbomb/1.3.1
Date: Tue, 27 Oct 2009 00:33:03 -0000
From: Marti Raudsepp <marti@juffo.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Marti Raudsepp <marti@juffo.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Posting two small user interface tweaks to perf.

[PATCH 1 of 2] perf tools: notify user when unrecognized event is specified

When you specify an unknown --event, perf now outputs:

  invalid or unsupported event: 'foobar'
  Run 'perf list' for a list of valid events

[PATCH 2 of 2] perf tools: output 'perf list' to stdout not stderr

I certainly expected 'perf list' output to be sent to stdout. It's not errors
or notices: the user asked for a list.

Marti

