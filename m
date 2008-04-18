Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbYDRMUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbYDRMUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 08:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYDRMUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 08:20:40 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:60313 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbYDRMUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 08:20:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rji4u5OgAq3p50kc5QjUuttQ4H9fMrBHjQj7EzZLw6l2Vy1skF1V++TUoeZmE0BbF0V3aknx+Gh1BK0pFEeqx3EfWeTTNskIf76NwIXvBZ/yk7f92nQ+4F/Z/CRr7EoXrWJW2uI0cWZmtNBLwkZuCXcrj/NBNce5uLQYZO83T7A=
Message-ID: <e7ca40f70804180520v5687a7ccv44c08320c8cd0bce@mail.gmail.com>
Date: Fri, 18 Apr 2008 08:20:37 -0400
From: "Aaron Wiebe" <epiphani@gmail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: nfs: lock stuck after interrupt
Cc: bfields@fieldses.org, trond.myklebust@fys.uio.no, eshel@almaden.ibm.com,
       neilb@suse.de, akpm@linux-foundation.org, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <E1JmoR2-0005j2-VU@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1JmY9Y-0004e4-7R@pomaz-ex.szeredi.hu>
	 <e7ca40f70804171230l31aa6978x6ebfb41f9e4e7ba7@mail.gmail.com>
	 <E1JmoR2-0005j2-VU@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 7:07 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:

>  2) then I added your patch on top of that, which did change something
>    but not really for the better: now even the restarted lock request
>    doesn't succeed after the interrupt.
>
> According to my suspicion, this is an issue in the server, while both
> referenced patches touch only the client.

Note that my little patch purely resolves the situation we were seeing
on the client side.  We were using Netapps for servers.

We're actually using that small patch, against 2.6.22, in production
right now and it has still solved our issue.

-Aaron
