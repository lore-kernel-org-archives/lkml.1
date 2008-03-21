Return-Path: <linux-kernel-owner+w=401wt.eu-S1759265AbYCUTLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265AbYCUTLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 15:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYCUTL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 15:11:29 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:16720 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbYCUTL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 15:11:28 -0400
Message-ID: <47E40856.6020902@googlemail.com>
Date: Fri, 21 Mar 2008 20:11:18 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Vlad Yasevich <vladislav.yasevich@hp.com>,
       Sridhar Samudrala <sri@us.ibm.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Commit 270637abff0cdf848b910b9f96ad342e1da61c66 introduced a lot
 new compiler warnings
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all ,

I noticed the following new compile warnings on current git head introduced by 270637abff0cdf848b910b9f96ad342e1da61c66 :

In file included from net/sctp/sm_statetable.c:50:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
In file included from net/sctp/sm_statefuns.c:62:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
In file included from net/sctp/protocol.c:60:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
In file included from net/sctp/sm_sideeffect.c:55:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
In file included from net/sctp/endpointola.c:55:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
In file included from net/sctp/associola.c:59:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
In file included from net/sctp/transport.c:53:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
In file included from net/sctp/chunk.c:46:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
In file included from net/sctp/sm_make_chunk.c:65:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
In file included from net/sctp/ulpevent.c:49:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
In file included from net/sctp/inqueue.c:46:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
In file included from net/sctp/outqueue.c:55:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
In file included from net/sctp/ulpqueue.c:48:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
In file included from net/sctp/command.c:42:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
In file included from net/sctp/tsnmap.c:46:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
In file included from net/sctp/bind_addr.c:50:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
In file included from net/sctp/socket.c:79:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
In file included from net/sctp/primitive.c:54:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
In file included from net/sctp/output.c:61:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
In file included from net/sctp/input.c:61:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
In file included from net/sctp/debug.c:48:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
In file included from net/sctp/ssnmap.c:40:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
In file included from net/sctp/proc.c:40:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
In file included from net/sctp/auth.c:40:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
In file included from net/sctp/sysctl.c:45:
include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void


Regards,

Gabriel
