Return-Path: <linux-kernel-owner+w=401wt.eu-S1752988AbZIYCUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbZIYCUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 22:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZIYCUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 22:20:13 -0400
Received: from dd2934.kasserver.com ([85.13.129.136]:36881 "EHLO
	dd2934.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbZIYCUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 22:20:12 -0400
Message-ID: <4ABC28DE.7050809@datenparkplatz.de>
Date: Fri, 25 Sep 2009 04:20:14 +0200
From: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: IO scheduler based IO controller V10
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> Notes:
> - With vanilla CFQ, random writers can overwhelm a random reader.
>   Bring down its throughput and bump up latencies significantly.


IIRC, with vanilla CFQ, sequential writing can overwhelm random readers,
too.

I'm basing this assumption on the observations I made on both OpenSuse
11.1 and Ubuntu 9.10 alpha6 which I described in my posting on LKML
titled: "Poor desktop responsiveness with background I/O-operations" of
2009-09-20.
(Message ID: 4AB59CBB.8090907@datenparkplatz.de)


Thus, I'm posting this to show that your work is greatly appreciated,
given the rather disappointig status quo of Linux's fairness when it
comes to disk IO time.

I hope that your efforts lead to a change in performance of current
userland applications, the sooner, the better.


Thanks
Ulrich
