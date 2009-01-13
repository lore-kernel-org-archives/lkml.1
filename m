Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbZAMWsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbZAMWsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 17:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbZAMWsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 17:48:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbZAMWsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 17:48:08 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: mtk.manpages@gmail.com
X-Fcc: ~/Mail/linus
Cc: "kernel list" <linux-kernel@vger.kernel.org>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>
Subject: Re: waitid() return value strangeness when infop is NULL
In-Reply-To: Michael Kerrisk's message of  Wednesday, 14 January 2009 11:38:18 +1300 <cfd18e0f0901131438n232ba114n27ea2d7964d071de@mail.gmail.com>
References: <cfd18e0f0901131436ud2cf61bkf0e6b00f4b765bb5@mail.gmail.com>
	<cfd18e0f0901131438n232ba114n27ea2d7964d071de@mail.gmail.com>
X-Shopping-List: (1) Blunt companions
   (2) Deoxyribonucleic trenchant chains
   (3) Irritating reinforcements
Message-Id: <20090113224759.7DFB7FC3DD@magilla.sf.frob.com>
Date: Tue, 13 Jan 2009 14:47:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> a) Is it intentional to support the infop==NULL case for waitid() --
> rather than simply giving an error return?

No.  It's just an artifact of the internals shared with wait4/waitpid.
Patch to follow.


Thanks,
Roland
