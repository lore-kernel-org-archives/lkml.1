Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbZKQVRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbZKQVRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 16:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZKQVRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 16:17:30 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:50311 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752921AbZKQVR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 16:17:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAAafAktGGN1W/2dsb2JhbACBTdV8hDsE
Date: Tue, 17 Nov 2009 16:17:34 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: [RELEASE] LTTng 0.173, ltt-control 0.76, lttv 0.12.22, trace
	format 2.5
Message-ID: <20091117211734.GA27103@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 16:13:14 up 91 days,  8:02,  4 users,  load average: 0.44, 0.28,
	0.16
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTTng 0.173 add support for variable-sized subbuffer transfers. Useful
for network trace streaming with a periodic timer to flush the buffers
periodically: only the actual payload (aligned to the next page) will be
sent.

LTTV now uses a block index to map the beginning of block offsets. It
does not require all blocks to have the same size anymore.
These changed required to push the trace format version to 2.5.

As always, all the goodies are available at http://lttng.org.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
