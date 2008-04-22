Return-Path: <linux-kernel-owner+w=401wt.eu-S1763407AbYDVRvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763407AbYDVRvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbYDVRvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:51:36 -0400
Received: from hu-out-0506.google.com ([72.14.214.225]:30664 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758488AbYDVRvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:51:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=kPldULYSHmWi8IKlAjhw1+c7nHyJ6IHuv+UW0UD+E4qEn7AVewlcM/cENB5fHPs7VN6Wsui10fvnuT3HnKZ7DF8wgSaq3f4ps57FBoFjx8pbyIFRDjxVakBHVSwLHvuXV76dvsCR9ZNV7RstG6dtdfppEEExC6IOjE1RmcEiD4c=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs: #define out unused parameters =?utf-8?q?of=09xfs=5Fbmap=5Fadd=5Ffree_and?= xfs_btree_read_bufl
Date: Tue, 22 Apr 2008 19:50:54 +0200
User-Agent: KMail/1.8.2
Cc: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20080419142329.GA5339@elte.hu> <20080422172156.GB28933@cs181133002.pp.htv.fi> <480E1FAE.20509@sandeen.net>
In-Reply-To: <480E1FAE.20509@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804221950.54827.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 April 2008 19:26, Eric Sandeen wrote:
> >> I want to eventually reach the state with no warnings
> >> about unused parameters.
> > 
> > The standard kernel pattern in using empty static inline functions (that 
> > allow type checking).
> > 
> > And I'm not sure whether the number of functions you'd have to change 
> > for reaching your goal has four, five or six digits.
> 
> It would be a huge undertaking.
> 
> Just building xfs w/ the warning in place exposes tons of unused
> parameter warnings from outside xfs as well.

Eh... I meant "no warnings about unused parameters" for fs/xfs/* only,
not for the entire kernel. I filter out other warnings.

I want to do it not as an excercise in perfectionism,
but as means of making sure we do not waste stack
passing useless parameters, which is important for xfs.
--
vda
