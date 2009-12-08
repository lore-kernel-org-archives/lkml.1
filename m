Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbZLHKHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbZLHKHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 05:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbZLHKHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 05:07:05 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:40243 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbZLHKHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 05:07:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Dhq/No9TJvyniDD+FPMunoIOoJB2a1zYqi64BmjsnzvQGkqlV1VHy6zD4LiDqTpHNw
         WtL3DQa5+5tBKTBPkCi+yrI90o5pyVdrZFeSIco6bFqLAKGMihkzGVqQEQ2S3Ec3uY8C
         lpP+kELus7MN4MFLIqgNGK1paih8Y7tmCYNAU=
Date: Tue, 8 Dec 2009 10:59:39 +0100
From: Richard Zidlicky <rz@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: 2.6.32 regression, hard lock
Message-ID: <20091208095939.GA2299@linux-m68k.org>
References: <20091206141419.GA6195@linux-m68k.org> <20091207143057.53c6a362.akpm@linux-foundation.org> <20091208002353.GA30011@linux-m68k.org> <20091207164826.eb2bbc48.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207164826.eb2bbc48.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > I did revert to 2.31.5 and to my big surprise found a similar thing happened
> > so it is not a regression, at least not from 2.6.31.

I will compare the messages in the 2 kernel versions. In 2.6.31 the symptoms were slightly
different, the ppp connection worked long after first processes became unresponsive.
"gnome-do" was apparently the first process to hang on the spinlock and tcptrack was 
running again.

Richard
