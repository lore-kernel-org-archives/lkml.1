Return-Path: <linux-kernel-owner+w=401wt.eu-S1756977AbYEPTzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977AbYEPTzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 15:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbYEPTzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 15:55:33 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:22360 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbYEPTzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 15:55:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VHVym8EdYH28PnqU2y4qScFMkbXMsTW0SuAkZfDqjRHpRRqp+YRkebgT0BTGpibO4u57X8UWE/PJGzWnC5X2K5zCEuS9RLOoSlfAvMZ9ImZS6J1zCkQLFv3/FplmPt+iz6UCc2XjdZRCpDwWqiity5QqZB5KwkuLfOSqajHab9s=
Message-ID: <170fa0d20805161255i31d768ceh3b15c2640f06524b@mail.gmail.com>
Date: Fri, 16 May 2008 15:55:30 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "device-mapper development" <dm-devel@redhat.com>, agk@redhat.com,
       "Ric Wheeler" <ric@emc.com>, "Michael Tokarev" <mjt@tls.msk.ru>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: [PATCH] Implement barrier support for single device DM devices
In-Reply-To: <20080219024533.GC4066@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080215120821.GA8267@basil.nowhere.org>
	 <20080215122002.GM29914@agk.fab.redhat.com>
	 <47B58EAA.8040405@msgid.tls.msk.ru>
	 <20080215142010.GA29552@one.firstfloor.org>
	 <20080215141229.GB1788@agk.fab.redhat.com> <47B97E87.6040209@emc.com>
	 <47B9870B.8060005@msgid.tls.msk.ru> <47B98D8A.7090506@emc.com>
	 <20080219024533.GC4066@agk.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 10:45 PM, Alasdair G Kergon <agk@redhat.com> wrote:
> On Mon, Feb 18, 2008 at 08:52:10AM -0500, Ric Wheeler wrote:
>  > I understand that. Most of the time, dm or md devices are composed of
>  > uniform components which will uniformly support (or not) the cache flush
>  > commands used by barriers.
>
>  As a dm developer, it's "almost none of the time" because trivial
>  configurations aren't the ones that require lots of testing effort.
>
>  Let's stop arguing over "most of the time":-)
>
>  As Andi points out, there are certainly enough real-world users of
>  "single linear or crypt target using one physical device" for it to be
>  worth our supporting it.

Hi Alasdair,

Given that you feel supporting barriers on single device DM targets is
a good thing, what is the status of such support (like Andi's patch)
making it upstream?

Mike
