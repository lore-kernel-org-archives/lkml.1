Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbYAOKBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbYAOKBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbYAOKAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:00:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:44413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbYAOKAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:00:40 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH] [2/31] CPA: Do a simple self test at boot
Date: Tue, 15 Jan 2008 10:59:09 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
References: <200801141116.534682000@suse.de> <20080114221633.B6A4814F93@wotan.suse.de> <1200386857.16794.2.camel@brick>
In-Reply-To: <1200386857.16794.2.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801151059.09467.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> global_flush_tlb outside CONFIG_CPA_DEBUG here.  Intentional?

Yes that's all intentional. Without CPA_DEBUG there is only a single flush,
with CPA_DEBUG we flush more often simply to catch bugs.

-Andi
