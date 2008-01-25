Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbYAYP41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbYAYP41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 10:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbYAYP4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 10:56:18 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37219 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbYAYP4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 10:56:17 -0500
To: jack@suse.cz
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       gorcunov@gmail.com
In-reply-to: <20080125153044.GF28856@atrey.karlin.mff.cuni.cz> (message from
	Jan Kara on Fri, 25 Jan 2008 16:30:44 +0100)
Subject: Re: [patch 25/26] mount options: fix udf
References: <20080124193341.166753833@szeredi.hu> <20080124193456.220272889@szeredi.hu> <20080125153044.GF28856@atrey.karlin.mff.cuni.cz>
Message-Id: <E1JIQub-0002Bd-CW@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 25 Jan 2008 16:56:13 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   Please use just 'int' for 'remount' option. We are slowly trying to
> get rid of these strange things in UDF code so adding new ones isn't
> desirable.

What's wrong with bool?

I'm not advocating mass replacements, but all new code _should_ use
it, because it's a very useful and good type.

We are just not very much used to it yet, but don't tell me it's
confusing to see a type like this ;)

Miklos
