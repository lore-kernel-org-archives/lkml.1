Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbXHHKwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbXHHKwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 06:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbXHHKw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 06:52:27 -0400
Received: from brick.kernel.dk ([87.55.233.238]:20673 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbXHHKw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 06:52:27 -0400
Date: Wed, 8 Aug 2007 12:52:23 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Sheplyakov Alexei <varg@theor.jinr.ru>
Cc: Andi Kleen <andi@firstfloor.org>, dragoran <drago01@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: allow non root users to set io priority "idle" ?
Message-ID: <20070808105223.GO5245@kernel.dk>
References: <46B6EDCB.6030806@gmail.com> <p73zm14lxyy.fsf@bingen.suse.de> <20070808095132.GA31020@theor.jinr.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070808095132.GA31020@theor.jinr.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08 2007, Sheplyakov Alexei wrote:
> So I think current behaviour of ionice is inconsistent (and pointless).

It is not, as has been explained more than once in this thread, we
cannot allow ordinary users to eg /etc/passwd infinitely. See?

It'd be nice if we could solve this of course, until then true idle io
must be a cautious root-only thing. So it may be inconsistent and a bit
confusing, but it's definitely not pointless.

-- 
Jens Axboe

