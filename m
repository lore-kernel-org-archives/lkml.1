Return-Path: <linux-kernel-owner+w=401wt.eu-S1762305AbYA1Vb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762305AbYA1Vb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 16:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbYA1Vbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 16:31:48 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:36957 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbYA1Vbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 16:31:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=mWZDkPPLrLVbxLXPAOkXFCAJV1qB2GCmQtsYrCrZlX+OBV56dlea25+AhCKPE0nE8GwWgpmVLo7jVgAtG7vQ4gIuMJZa9DFxy1oGHsUIrEuGHo2MY9hpXFMhFE8QqOqp/trtt6LPkZAt2CXrGtQ0I9Y+C30TDcUqcOg4wYHLZ2w=
Date: Mon, 28 Jan 2008 19:30:11 -0200
From: Leonardo Baldelli <leitoox@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [BUG] 2.6.24 net/core/dev.c:1416 skb_gso_segment()
Message-ID: <20080128193011.6a5898be@lara>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: at net/core/dev.c:1416 skb_gso_segment()
Pid: 0, comm: swapper Tainted: P        2.6.24 #1

Call Trace:
 <IRQ>  [<ffffffff811c4496>]
 [<ffffffff811c4736>]
 [<ffffffff81028c39>]
 [<ffffffff811d24b4>]
 [<ffffffff811c6e18>]
 [<ffffffff811e1163>]
 [<ffffffff88603d35>]
 [<ffffffff8103aa24>]
 [<ffffffff811f1e4a>]
 [<ffffffff811ea74e>]
 [<ffffffff811f3b4f>]
 [<ffffffff8107bad9>]
 [<ffffffff8107bc95>]
 [<ffffffff811f0f1f>]
 [<ffffffff811f75e5>]
 [<ffffffff811d93a7>]
 [<ffffffff81028c39>]
 [<ffffffff811f9dd0>]
 [<ffffffff81028c39>]
 [<ffffffff811dbcf5>]
 [<ffffffff811dc0fe>]
 [<ffffffff81214543>]
 [<ffffffff811c4032>]
 [<ffffffff811c6b14>]
 [<ffffffff811c64e3>]
 [<ffffffff81036955>]
 [<ffffffff81023675>]
 [<ffffffff8100cdec>]
 [<ffffffff8100ee85>]
 [<ffffffff8100f0e0>]
 [<ffffffff8100ace0>]
 [<ffffffff8100ace0>]
 [<ffffffff8100c171>]
 <EOI>  [<ffffffff8100ad09>]
 [<ffffffff8100ad8a>]
 [<ffffffff812e1b5a>]
 [<ffffffff812e112d>]
