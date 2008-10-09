Return-Path: <linux-kernel-owner+w=401wt.eu-S1758697AbYJIQne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697AbYJIQne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 12:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbYJIQnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 12:43:24 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38151 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbYJIQnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 12:43:23 -0400
To: schwab@suse.de
CC: miklos@szeredi.hu, torvalds@linux-foundation.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <jeskr5g29i.fsf@sykes.suse.de> (message from Andreas Schwab on
	Thu, 09 Oct 2008 18:30:01 +0200)
Subject: Re: splice vs O_APPEND
References: <E1Knx26-0003ds-Ch@pomaz-ex.szeredi.hu>
	<alpine.LFD.2.00.0810090830170.3210@nehalem.linux-foundation.org>
	<E1Knxzm-0003y2-Jy@pomaz-ex.szeredi.hu> <jeskr5g29i.fsf@sykes.suse.de>
Message-Id: <E1KnybM-0004AD-3V@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 09 Oct 2008 18:43:00 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Oct 2008, Andreas Schwab wrote:
> Miklos Szeredi <miklos@szeredi.hu> writes:
> 
> > pwrite() for example honors O_APPEND and ignores the position, AFAICS.
> 
> If it does, then it violates POSIX (see

I checked and it does.  Nobody seems to care though, not even the
POSIX conformance checkers :)

Miklos
