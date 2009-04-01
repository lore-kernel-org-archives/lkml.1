Return-Path: <linux-kernel-owner+w=401wt.eu-S1756479AbZDAAa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbZDAAa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZDAAas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:30:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53385 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787AbZDAAaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:30:46 -0400
Date: Wed, 1 Apr 2009 02:26:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, juan.villacis@intel.com, ak@linux.jf.intel.com
Subject: Re: [patch 3/21] x86, bts: wait until traced task has been
	scheduled out
Message-ID: <20090401002657.GE28228@redhat.com>
References: <20090331145947.A12565@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090331145947.A12565@sedona.ch.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for noise, forgot to mention...

On 03/31, Markus Metzger wrote:
>
>  static inline struct ds_context *ds_get_context(struct task_struct *task)

Completely off-topic, but ds_get_context() is rather fat, imho makes
sense to uninline.

Oleg.

