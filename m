Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbZBKITH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbZBKITH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 03:19:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbZBKISy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 03:18:54 -0500
Received: from bc.sympatico.ca ([209.226.175.184]:53856 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753372AbZBKISx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 03:18:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEALASkklMQWt2/2dsb2JhbACBbtFnhBoG
Date: Wed, 11 Feb 2009 03:18:50 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: LTTng 0.92 for kernel 2.6.29-rc4
Message-ID: <20090211081850.GA13661@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 03:08:43 up 41 days,  8:06,  4 users,  load average: 0.47, 0.31,
	0.28
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just released a much reworked patchset for 2.6.29-rc4. I reordered the
patches to put the core of the tracer at the beginning and the
instrumentation at the end. I tried to make it bissectable, but more
work would be required to make it completely so.

The patch jbd2-instrumentation-move-to-tracepoints.patch should be a
bissection point which indicates the end of the core tracer patches.
Everything should build at this patch, without any instrumentation.

You will need to upgrade to ltt-control 0.65 to get the new ltt-armall
script which uses the new debugfs marker control interface.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
