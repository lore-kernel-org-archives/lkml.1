Return-Path: <linux-kernel-owner+w=401wt.eu-S1762307AbZATBdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762307AbZATBdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 20:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756563AbZATBdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 20:33:09 -0500
Received: from relay2.sgi.com ([192.48.179.30]:42110 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753976AbZATBdH (ORCPT
	<rfc822;@relay.corp.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 20:33:07 -0500
Message-Id: <20090120012930.020621000@sgi.com>
User-Agent: quilt/0.44-16.4
Date: Tue, 20 Jan 2009 12:29:30 +1100
From: Greg Banks <gnb@sgi.com>
To: Linux Kernel ML <linux-kernel@vger.kernel.org>
Cc: Linux NFS ML <linux-nfs@vger.kernel.org>,
       Linux NFSv4 ML <nfsv4@linux-nfs.org>,
       SystemTAP ML <systemtap@sources.redhat.com>
Subject: [patch 0/5] activate & deactivate dprintks individually and severally
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mentioned in the recent discussion on NFS trace points on the NFS &
SystemTap mailing lists.  This patch allows field support staff and
kernel developers debug kernel problems, by enabling them to treat
dprintks as precise trace points rather than syslog spamming tools.

This is a forward ported (from 2.6.16), updated, and split version
of a patch that has been used in SGI's internal development tree for
the last few months.  The very first version of this was used about
eighteen months ago when debugging NFS/RDMA, which has an enormous
number of dprintks and no other way to debug it.

Jason Baron suggested I post it here for review and contrast with
his dynamic dprintk feature.

-- 
Greg Banks, P.Engineer, SGI Australian Software Group.
the brightly coloured sporks of revolution.
I don't speak for SGI.
