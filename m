Return-Path: <linux-kernel-owner+w=401wt.eu-S1751878AbZFXHHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbZFXHHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbZFXHHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:07:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59826 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbZFXHHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:07:06 -0400
Date: Wed, 24 Jun 2009 09:07:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: liqin.chen@sunplusct.com
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: S+core architecture (arch/score/) support files
Message-ID: <20090624070708.GI6760@one.firstfloor.org>
References: <87zlbz17fb.fsf@basil.nowhere.org> <OF06F6A918.AA4716A4-ON482575DF.000B4993-482575DF.0013010F@sunplusct.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF06F6A918.AA4716A4-ON482575DF.000B4993-482575DF.0013010F@sunplusct.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think merge score to upstream will be no harm to linux kernel.

The problem is just that if the code is not tested in its
current configuration it will most likely not work (unless you're a perfect 
coder, but most of us are not). And merging code that doesn't work doesn't
make sense.

The need for a full retest after the changes inspired by review
feedback is somewhat annoying -- I agree -- but there's really
no way around it that I know.

BTW I'm not saying that LTP is the perfect user test (it's definitely
not), but it's a relatively useful basic sanity check and you
should pass something like this at least. Other real user testing would
be still needed too of course then.

-Andi
  
-- 
ak@linux.intel.com -- Speaking for myself only.
