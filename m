Return-Path: <linux-kernel-owner+w=401wt.eu-S1764048AbXGKMV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764048AbXGKMV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761440AbXGKMVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:21:20 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34214 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761393AbXGKMVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:21:19 -0400
Date: Wed, 11 Jul 2007 18:00:48 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: containers@lists.osdl.org, menage@google.com, Paul Jackson <pj@sgi.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: containers (was Re: -mm merge plans for 2.6.23)
Message-ID: <20070711123048.GA31130@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070710105240.GA20914@linux.vnet.ibm.com> <6599ad830707101134k29951c45h4af0807603f52b76@mail.gmail.com> <20070710115319.0bdaff34.akpm@linux-foundation.org> <20070711045516.GH2927@linux.vnet.ibm.com> <20070710222942.382fc9ba.akpm@linux-foundation.org> <20070711090423.GA6758@elte.hu> <20070711022352.71604404.pj@sgi.com> <20070711100323.GA23473@linux.vnet.ibm.com> <20070711101958.GA10095@elte.hu> <20070711113953.GB23473@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711113953.GB23473@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 05:09:53PM +0530, Srivatsa Vaddagiri wrote:
> > (btw., if this goes into 2.6.23 then we cannot possibly turn it off in 2.6.24,
> 
> The fact that we will have two interface for group scheduler in 2.6.24
> is what worries me a bit (one user-id based and other container based).

I know breaking user-interface is a bad thing across releases. But in
this particular case, it's probably ok (since fair-group scheduling is a
brand new feature in Linux)?

If we have that option of breaking API between 2.6.23 and 2.6.24
for fair-group scheduler, then we are in a much more flexible position.

For 2.6.23, I can send a user-id based interface for fair-group
scheduler (with some /proc interface to tune group nice value).

For 2.6.24, this user-id interface will be removed and we will instead
switch to container based interface. Fair-user scheduling will continue
to work, its just that users will have to use a daemon (sources sent in
previous mail) to enable it on top of container-based interface.

Hmm..?

-- 
Regards,
vatsa
