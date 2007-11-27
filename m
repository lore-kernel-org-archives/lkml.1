Return-Path: <linux-kernel-owner+w=401wt.eu-S1757788AbXK0ANR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788AbXK0ANR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 19:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657AbXK0ANI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 19:13:08 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45171 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754960AbXK0ANH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:13:07 -0500
Message-Id: <20071127001151.709076611@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 26 Nov 2007 16:11:51 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 00/14] Per cpu code simplification
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset simplifies the code that arches need to maintain to support
per cpu functionality. Most of the code is moved into arch independent
code. Only a set of minimal definitions is kept for each arch.

The patch also unifies the x86 arch so that there is only a single
asm-x86/percpu.h

-- 
