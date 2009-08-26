Return-Path: <linux-kernel-owner+w=401wt.eu-S932728AbZHZMUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728AbZHZMUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 08:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932579AbZHZMUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 08:20:36 -0400
Received: from ozlabs.org ([203.10.76.45]:43509 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932572AbZHZMUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 08:20:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Roland McGrath <roland@redhat.com>
Subject: Re: kernel segv with 2.6.31-rc6 ?
Date: Wed, 26 Aug 2009 21:50:34 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Helge Deller <deller@gmx.de>,
       "linux-parisc" <linux-parisc@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4A89CC4D.5040801@gmx.de> <200908251729.32855.rusty@rustcorp.com.au> <20090825192432.4D9CC411E3@magilla.sf.frob.com>
In-Reply-To: <20090825192432.4D9CC411E3@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908262150.34616.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009 04:54:32 am Roland McGrath wrote:
> > Actually, x86 was one of the archs which fucked us.  Richard Henderson and
> > I *had* this, but ld -shared without -fPIC helpfully tells you "you're doing
> > it wrong" on x86-64.
> 
> This complaint could easily be (have been) made optional.

Yep, I even had a patch.  And meanwhile we could have lived with -fPIC modules
with some loss of performance (I think).

But at some level the problems accumulate until you go "nice idea, let's go
do something else" :)

But don't let me discourage you!
Rusty.
