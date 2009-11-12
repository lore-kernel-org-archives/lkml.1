Return-Path: <linux-kernel-owner+w=401wt.eu-S1751750AbZKLLF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbZKLLF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 06:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbZKLLF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 06:05:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbZKLLF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 06:05:56 -0500
Subject: Re: [PATCH] drm/radeon/kms: Fix oops when set_base is call with no
 FB
From: Jerome Glisse <jglisse@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: airlied@gmail.com, dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
In-Reply-To: <20091110143056.defb1a82.akpm@linux-foundation.org>
References: <1257361399-5128-1-git-send-email-jglisse@redhat.com>
	 <20091110143056.defb1a82.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Organization: redhat.com
Date: Thu, 12 Nov 2009 12:02:58 +0100
Message-Id: <1258023778.2473.2.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 14:30 -0800, Andrew Morton wrote:
> On Wed,  4 Nov 2009 20:03:19 +0100
> Jerome Glisse <jglisse@redhat.com> wrote:
> 
> > Just do nothings crct_set_base i call with no FB.
> > 
> 
> hmpf.  It's obvious that you spent hours carefully describing this
> patch for us.
> 

Sorry, truth is i don't understand why crtc set_base call back
can be call with a null fb, i did just replicate what intel kms
and other part of radeon kms was doing in front of such situation.
It should go down to 2.6.31, useless before as there is no KMS
for radeon in earlier version. The oops will happen when user
switch btw X & vt or in some case when changing mode.

Will clearly state my ignorance in future patch.

Cheers,
Jerome

