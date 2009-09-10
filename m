Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbZIJTRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbZIJTRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 15:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbZIJTRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 15:17:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbZIJTRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 15:17:44 -0400
Date: Thu, 10 Sep 2009 21:13:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] resend, cpuset/hotplug fixes
Message-ID: <20090910191345.GA32635@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 1st patch is preparation. 2-3 fix different problems, the 3rd one
depends on 2nd.

These patches change the code which I don't really understand, please
review.


As for the 3rd patch, it replaces

	cpu_hotplug-dont-affect-current-tasks-affinity.patch

in -mm tree. Imho the new patch is more simple and clean, but of course
this is subjective and I am biased.

Oleg.

