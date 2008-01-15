Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbYAOKI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbYAOKI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbYAOKH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:07:59 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:49351 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197AbYAOKH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:07:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nMzD/qvfNHiK2/wL1WojEifz3ZLjr6SWQw37leOpIhZL+zfBFbMU1lcUyHOwdWRBVDPWWQvkEucnKejAYP1lm7IH5JQXRhT1nxaajcJn6crUg6eeK/yNCHtQtUfJ7J70u6ARbUhLEKDVIEGd2gJ9p/DC671e7jyRLE/6Q1IRLWU=
Subject: Re: [PATCH] [2/31] CPA: Do a simple self test at boot
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
In-Reply-To: <200801151059.09467.ak@suse.de>
References: <200801141116.534682000@suse.de>
	 <20080114221633.B6A4814F93@wotan.suse.de> <1200386857.16794.2.camel@brick>
	 <200801151059.09467.ak@suse.de>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 02:07:59 -0800
Message-Id: <1200391679.16794.22.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-15 at 10:59 +0100, Andi Kleen wrote:
> > global_flush_tlb outside CONFIG_CPA_DEBUG here.  Intentional?
> 
> Yes that's all intentional. Without CPA_DEBUG there is only a single flush,
> with CPA_DEBUG we flush more often simply to catch bugs.
> 

OK, it just looked a bit fishy with the different grouping, just making
sure.

Harvey

