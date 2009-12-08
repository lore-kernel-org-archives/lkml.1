Return-Path: <linux-kernel-owner+w=401wt.eu-S966068AbZLHUdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966068AbZLHUdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:33:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936711AbZLHUdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:33:00 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:50237 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935789AbZLHUc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:32:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hq/eAGA1HHQACy9WxvqA3gbmXyE5sH9YTPTCpR5qdxS9mACs0Zd/WXUs22N/IwKrAI
         Do3qPfYMjeNumJxRfSqTizGNDK56qgilfiC4WjzX9UEuNCmtomcnz4zXggFpqEPdoMWQ
         5CdLip2eE2RMF3spO4NditSENJuvalsFain4s=
Date: Tue, 8 Dec 2009 21:25:41 +0100
From: Richard Zidlicky <rz@linux-m68k.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.32 regression, hard lock
Message-ID: <20091208202541.GB6322@linux-m68k.org>
References: <20091206141419.GA6195@linux-m68k.org> <20091207143057.53c6a362.akpm@linux-foundation.org> <20091208002353.GA30011@linux-m68k.org> <20091207164826.eb2bbc48.akpm@linux-foundation.org> <s5hocm9som6.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hocm9som6.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 12:15:45PM +0100, Takashi Iwai wrote:

> 
> But, as Andrew pointed, this should be irrelevant with the IRQ
> lockup.  At most it could be a dead-locking of PA and other
> sound-related processes, but I've never heard the real issue.

indeed, had to kill and restart PA on a few occassions but no other
ill effects so far.

Richard
