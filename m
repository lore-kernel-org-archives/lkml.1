Return-Path: <linux-kernel-owner+w=401wt.eu-S1757616AbZCRQgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbZCRQgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 12:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbZCRQfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 12:35:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756977AbZCRQfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 12:35:46 -0400
Message-ID: <49C122DF.7020803@redhat.com>
Date: Wed, 18 Mar 2009 12:35:43 -0400
From: William Cohen <wcohen@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Documenting kernel tracepoints
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a number of tracepoints in the latest kernels, but not much
documentation on the tracepoints.  If a very recent version of
systemtap is available on the system, a list of the probe points can
be obtained with:

stap -p2 -e 'probe kernel.trace("*") {exit()}'|sort

However, this only provides the names. It doesn't provide information
about what information the probe point provides or the arguments
available at the probe point.

Currently, a number of kernel functions and structures are documented
with embedded comments that are extracted with kernel-doc. Seems like
it would be reasonable to extend this to support tracepoints.
Any thoughts or comments about this approach?

-Will
