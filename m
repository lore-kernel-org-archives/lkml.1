Return-Path: <linux-kernel-owner+w=401wt.eu-S932620AbZKMXmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620AbZKMXmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932462AbZKMXmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:42:21 -0500
Received: from ozlabs.org ([203.10.76.45]:41884 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932326AbZKMXmV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:42:21 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Thiago Farina <tfransosi@gmail.com>
Subject: Re: [PATCH v4 2/2] bsearch: prevent overflow when computing middle comparison element
Date: Sat, 14 Nov 2009 10:12:18 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: =?utf-8?q?Andr=C3=A9_Goddard_Rosa?= <andre.goddard@gmail.com>,
       tabbott@ksplice.com, alan-jenkins@tuffmail.co.uk,
       linux-kernel@vger.kernel.org
References: <cover.1257864802.git.andre.goddard@gmail.com> <200911122336.11033.rusty@rustcorp.com.au> <a4c8a6d00911130703v44dcb920h81a41378ec7b026b@mail.gmail.com>
In-Reply-To: <a4c8a6d00911130703v44dcb920h81a41378ec7b026b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200911141012.19050.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Nov 2009 01:33:04 am Thiago Farina wrote:
> Hi Rusty,
> 
> On Thu, Nov 12, 2009 at 11:06 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > On Wed, 11 Nov 2009 01:30:25 am André Goddard Rosa wrote:
> >> It's really difficult to occur in practice because the sum of the lower
> >> and higher limits must overflow an int variable, but it can occur when
> >> working with large arrays. We'd better safe than sorry by avoiding this
> >> overflow situation when computing the middle element for comparison.
> >
> > I applied all these, after testing.  In future would have been nice for you
> > to have posted a test patch so I didn't have make my own...
> 
> Where did you apply this patch?

To my kernel series, which means it is now in linux-next.

Hope that helps,
Rusty.
