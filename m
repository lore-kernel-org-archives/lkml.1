Return-Path: <linux-kernel-owner+w=401wt.eu-S1758148AbXFUSVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbXFUSVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbXFUSVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:21:43 -0400
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:59247 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754876AbXFUSVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:21:43 -0400
From: Johannes Schlumberger <spjsschl@stud.informatik.uni-erlangen.de>
Date: Thu, 21 Jun 2007 20:21:42 +0200
To: Adrian Bunk <bunk@stusta.de>
Cc: Alexander Wuerstlein <snalwuer@cip.informatik.uni-erlangen.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signed binaries support [0/4]
Message-ID: <20070621182142.GA24218@faui01.informatik.uni-erlangen.de>
References: <20070621155516.GA6838@faui01.informatik.uni-erlangen.de> <20070621161758.GP12950@stusta.de> <20070621162917.GB9741@cip.informatik.uni-erlangen.de> <20070621172344.GQ12950@stusta.de> <20070621173445.GF9741@cip.informatik.uni-erlangen.de> <20070621180557.GR12950@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070621180557.GR12950@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > Even if it does not really improve security too much it can be helpful as a
> > part of a larger system. For example around here we use a 'sbit-checker' that
> > basically does a 'find' and 'chmod', which we would be able to replace by this
> > patch.
> 
> Something that sounds as if it would increase security but doesn't 
> really increase security is actually bad since it gives users a false 
> impression of security.

We are aware of the limitations, this approach has. It is not designed to make
every bit of executed code trusted, because that what just be the same as
before. Everything would be given the same amount of trust.
What we do, is establish a caste of binaries and processes more trusted than the
rest, which could be used for special tasks.
 
> > Also our patch is not solely about suid-binaries, we just implemented
> > suid-checking because it seemed a simple and obvious thing to do.  Our real aim
> > was to implement binary signatures, which can be used in numerous security
> > related checks around the kernel. Btw. if you have any good ideas where one
> > could use them, please tell us :)
 
> Does writing an ELF loader in perl circumvent everything you want to do?

No, it  does not. We do check any executable pages.
regards,
	Johannes 

-- 
Johannes Schlumberger                      Department of Computer Science IV
Martensstrasse 1  D-91058 Erlangen Germany  University of Erlangen-Nuremberg
             http://wwwcip.informatik.uni-erlangen.de/~spjsschl
