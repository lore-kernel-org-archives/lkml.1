Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbYAIA1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbYAIA1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 19:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbYAIA1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:27:34 -0500
Received: from gate.crashing.org ([63.228.1.57]:53767 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbYAIA1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:27:33 -0500
Subject: Re: Replacement for page fault notifiers?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Dave Airlie <airlied@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       linux-kernel@vger.kernel.org, jbeulich@novell.com, proski@gnu.org
In-Reply-To: <21d7e9970801081413n307ab07aq462a9fff014143ae@mail.gmail.com>
References: <20080108210638.5c9e093a@daedalus.pq.iki.fi>
	 <20080108203235.GA772@infradead.org>
	 <21d7e9970801081413n307ab07aq462a9fff014143ae@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 11:26:47 +1100
Message-Id: <1199838407.6734.83.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Christoph,
> 
> it is generic code, it works by patching the module you load and is in
> no way nvidia specific, I think we should revert your chance
> as the notifiers have a valid user and one it has been planned to upstream..

Agreed, it looks like a sane enough user of page fault notifiers, it's
going to be upstream, and it's useful to fight evil binary drivers so
that sounds like a good justification to bring those back in :-)

Cheers,
Ben.


