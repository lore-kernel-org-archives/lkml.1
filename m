Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbYCLVUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbYCLVUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 17:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYCLVUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 17:20:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:32040 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbYCLVUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 17:20:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wKWcUY5RAyv9LBbGGnrGB1NsLeFeCh4xBMtCBU+Yv5TihFoAADapMcyMRvfLc+o+KOAYTtUIZcPL7Jhp4eBCW06NhzJgPcIT8dUljO/P6W+RP1vqLb7RYDt+YMp4yT9VIXdZfTa4Rpe2lI69LNqnEPl9n1P2yDmZc/e37pvvwKE=
Subject: Re: + n_tty-loss-of-sync-following-a-buffer-overflow.patch added
	to -mm tree
From: Rupesh Sugathan <rupesh.sugathan@gmail.com>
Reply-To: rupesh.sugathan@gmail.com
To: Paul Fulghum <paulkf@microgate.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <47D844B5.2090001@microgate.com>
References: <200803120455.m2C4t4Aw010881@imap1.linux-foundation.org>
	 <20080312102729.58956d2c@the-village.bc.nu>
	 <47D7F531.2070400@microgate.com>  <1205339539.8873.14.camel@estonia>
	 <1205343590.4094.17.camel@x2.microgate.com>
	 <47D844B5.2090001@microgate.com>
Content-Type: text/plain
Date: Wed, 12 Mar 2008 13:54:43 -0700
Message-Id: <1205355283.8873.29.camel@estonia>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Paul Fulghum wrote:
> > What I suggest is the following patch for processing NL
> > in canonical mode.

I tested the patch in 2.4.x and seems to meet all the discussed
requirements. 

I have another suggestion to this subject. When the buffer oveflows in
icaonon mode, it would be *best* if the application either gets a
complete line or does not get it at all. On a buffer overflow, it would
be good that the n_tty discard the whole line data in the buffer (part
of which has overflown) and make more room in the buffer.

Does it make sense to any of you?

--
Rupesh Sugathan

