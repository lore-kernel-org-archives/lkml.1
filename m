Return-Path: <linux-kernel-owner+w=401wt.eu-S1759544AbYGPVnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544AbYGPVnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 17:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757422AbYGPVnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 17:43:45 -0400
Received: from rn-out-0910.google.com ([64.233.170.191]:60550 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbYGPVno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 17:43:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hRdbHyZjE0NpKZvznaQK+VIwom7X3OyGg2sN/jra/62yD81Sx5WWeSVNmd6RAcnNam
         rZHdQzNy974aV5s7pi2NUKxzjd9UaN4tIrmjdyw3QExIxGSEYcS63dTnOgNoUUE2ftWf
         Y1yUj6n+F3QSHYxloiSW9AeCu9qwSqdEUZkaU=
Subject: Re: [PATCH] dlm: sparse endian annotations
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Teigland <teigland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080716213801.GK28946@ZenIV.linux.org.uk>
References: <1216239367.28841.22.camel@brick>
	 <20080716213801.GK28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 14:43:41 -0700
Message-Id: <1216244621.28841.35.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-16 at 22:38 +0100, Al Viro wrote:
> On Wed, Jul 16, 2008 at 01:16:07PM -0700, Harvey Harrison wrote:
> 
> 
> NAK on ones below.  You are only hiding the warnings; ...s() is not making
> it any better.
> 

I'd suggest that any use of {endian}s() points to code that should be
looked at.  But if you'd also rather have the warnings, so be it.

Cheers,

Harvey

