Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbZGBSOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbZGBSOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 14:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZGBSOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 14:14:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36364 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbZGBSOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 14:14:33 -0400
Date: Thu, 2 Jul 2009 20:11:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ratan Nalumasu <rnalumasu@gmail.com>,
       Roland McGrath <roland@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] do not place sub-threads on task_struct->children list
Message-ID: <20090702181143.GA28577@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While this change is rather simple, it is of course dangerous.
Because it is not possible to grep for children/sibling usage.
So it needs testing.

OTOH, this change is obviously good optimization.

The patch does not depend on other changes.

Oleg.

