Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbXHHKRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbXHHKRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 06:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbXHHKRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 06:17:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35976 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbXHHKRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 06:17:01 -0400
Date: Wed, 8 Aug 2007 12:17:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Lee Revell <rlrevell@joe-job.com>
Cc: Andi Kleen <andi@firstfloor.org>, dragoran <drago01@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: allow non root users to set io priority "idle" ?
Message-ID: <20070808101659.GB12861@one.firstfloor.org>
References: <46B6EDCB.6030806@gmail.com> <p73zm14lxyy.fsf@bingen.suse.de> <75b66ecd0708071926s519ebcf5t680c2ed8ab7ead8e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75b66ecd0708071926s519ebcf5t680c2ed8ab7ead8e@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't think it's a problem for high priority (RT) tasks - it's well
> known in the real time Linux community that you never, ever do IO from
> a thread that has to satisfy RT constraints.  

The point here is to protect the system from a potentially malicious user

> which I would
> expect to take fewer locks.  

Even a single lock is one too much. My example lock -- the page lock bit --
certainly applies to both reads and writes.

-Andi
