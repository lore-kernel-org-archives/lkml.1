Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbZGHSQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbZGHSQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 14:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbZGHSQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 14:16:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42505 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbZGHSQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 14:16:02 -0400
Date: Wed, 8 Jul 2009 14:15:50 -0400
From: Dave Jones <davej@redhat.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] cpufreq: fix UP build
Message-ID: <20090708181550.GB13944@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Alexander Beregalov <a.beregalov@gmail.com>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	mathieu.desnoyers@polymtl.ca
References: <1247075867-11355-1-git-send-email-a.beregalov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247075867-11355-1-git-send-email-a.beregalov@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 09:57:47PM +0400, Alexander Beregalov wrote:
 > From: Alexander Beregalov <a.beregalov@gmail.com> 
 > 
 > Fix this build error when CONFIG_SMP is not set:
 > drivers/cpufreq/cpufreq.c:941: 'managed_policy' undeclared
 > 
 > Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
 
Ugh, should have caught this at merge time. Thanks.

I'll add a test to my scripts to do non-SMP build testing before merging.

	Dave
 
