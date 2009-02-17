Return-Path: <linux-kernel-owner+w=401wt.eu-S1751964AbZBQIQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbZBQIQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 03:16:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbZBQIPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 03:15:54 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:42147 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbZBQIPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 03:15:53 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: "elf core dump: fix get_user use" breaks mips compilation
Date: Tue, 17 Feb 2009 09:15:50 +0100
User-Agent: KMail/1.9.9
Cc: Martin Michlmayr <tbm@cyrius.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
References: <20090216120136.GA9057@deprecation.cyrius.com> <20090216233216.GA19484@linux-mips.org>
In-Reply-To: <20090216233216.GA19484@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902170915.50998.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Tuesday 17 February 2009 00:32:16 schrieb Ralf Baechle:
> On Mon, Feb 16, 2009 at 01:01:36PM +0100, Martin Michlmayr wrote:
> > Hi Roland,
> >
> > Your change "elf core dump: fix get_user use"  (which made it into
> > 2.6.28.5) breaks the compilation on MIPS (which sets -Werror):

Since several gcc versions are known to produce false warning, the proper
fix should be to remove -Werror, no?

Christian
