Return-Path: <linux-kernel-owner+w=401wt.eu-S932397AbZKMWvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbZKMWvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 17:51:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932320AbZKMWvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 17:51:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932317AbZKMWvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 17:51:11 -0500
Date: Fri, 13 Nov 2009 14:50:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jerome Glisse <jglisse@redhat.com>
Cc: airlied@gmail.com, dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/radeon/kms: Fix oops when set_base is call with no
 FB
Message-Id: <20091113145031.a8fe75a5.akpm@linux-foundation.org>
In-Reply-To: <1258023778.2473.2.camel@localhost>
References: <1257361399-5128-1-git-send-email-jglisse@redhat.com>
	<20091110143056.defb1a82.akpm@linux-foundation.org>
	<1258023778.2473.2.camel@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009 12:02:58 +0100
Jerome Glisse <jglisse@redhat.com> wrote:

> On Tue, 2009-11-10 at 14:30 -0800, Andrew Morton wrote:
> > On Wed,  4 Nov 2009 20:03:19 +0100
> > Jerome Glisse <jglisse@redhat.com> wrote:
> > 
> > > Just do nothings crct_set_base i call with no FB.
> > > 
> > 
> > hmpf.  It's obvious that you spent hours carefully describing this
> > patch for us.
> > 
> 
> Sorry, truth is i don't understand why crtc set_base call back
> can be call with a null fb, i did just replicate what intel kms
> and other part of radeon kms was doing in front of such situation.
> It should go down to 2.6.31, useless before as there is no KMS
> for radeon in earlier version. The oops will happen when user
> switch btw X & vt or in some case when changing mode.
> 
> Will clearly state my ignorance in future patch.
> 

I added a bit more waffle to the changelog.

Is a copy of this oops available anywhere?  Seeing the backtrace would
help people work out what the bug is.

