Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbXLHT64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbXLHT64 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 14:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbXLHT6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 14:58:49 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:38842 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbXLHT6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 14:58:49 -0500
Subject: Re: Possible locking issue in viotape.c
From: Daniel Walker <dwalker@mvista.com>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <475AEE30.4070806@gmail.com>
References: <20071206021857.826386004@mvista.com>
	 <20071206021909.131993721@mvista.com>  <20071206102334.GE17299@elte.hu>
	 <1196958847.1568.98.camel@jnielson-xp.ddns.mvista.com>
	 <47588610.5010804@gmail.com>
	 <1196989515.1568.131.camel@jnielson-xp.ddns.mvista.com>
	 <4758A216.3030401@gmail.com>
	 <1196991637.1568.140.camel@jnielson-xp.ddns.mvista.com>
	 <475ADFC5.4030108@gmail.com>
	 <1197138162.1568.172.camel@jnielson-xp.ddns.mvista.com>
	 <475AEE30.4070806@gmail.com>
Content-Type: text/plain
Date: Sat, 08 Dec 2007 11:45:00 -0800
Message-Id: <1197143100.1568.182.camel@jnielson-xp.ddns.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-12-08 at 15:19 -0400, Kevin Winchester wrote:

> 
> Yes, I've used quilt for working with mm patches in the past, but I'm
> not too familiar with the mail features.  For example, how do you get
> the recipient list and Signed-off-by in the patch file?  Do you just
> edit it by hand?  Or is there some guide to quilt I should be reading?
> I looked at the guide in /usr/share/doc/quilt/quilt.pdf, but it didn't
> have anything about email.  /usr/share/doc/quilt/README.MAIL has the
> details of all of the mail options, but doesn't give a nice example of
> what to do with the patch file and how to call 'quilt mail'.

The patch description and Signed-off-by, is added with the command
"quilt header -e" which opens and editor.. I usually use something like
this to mail out patches 

'quilt mail --send --to="akpm@linux-foundation.org" --cc="linux-kernel@vger.kernel.org"'

That's how you add the recipients ..

Daniel

