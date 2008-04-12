Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbYDLRbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbYDLRbR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 13:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbYDLRbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 13:31:04 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47770 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488AbYDLRbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 13:31:04 -0400
Date: Sat, 12 Apr 2008 10:29:33 -0700
From: sukadev@us.ibm.com
To: Andrew Morton <akpm@osdl.org>
Cc: serue@us.ibm.com, matthltc@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Helper patches for PTY namespaces
Message-ID: <20080412172933.GA19295@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some simple helper patches to enable implementation of multiple PTY
(or device) namespaces.

	[PATCH 1/4]: Propagate error code from devpts_pty_new
	[PATCH 2/4]: Factor out PTY index allocation
	[PATCH 3/4]: Move devpts globals into init_pts_ns
	[PATCH 3/4]: Enable multiple mounts of /dev/pts

This patchset is based on earlier versions developed by Serge Hallyn
and Matt Helsley.
