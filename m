Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbYHHAvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbYHHAvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbYHHAuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:50:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:41876 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbYHHAux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:50:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=x/LQCEeLa5VEOG1f072JRFkMMNjjmZT2Dvi2lRwuDqpHmoJHT2jDxpB8sbNrysNZyv
         qlOZ+gecHBrLEA5Q+gub+ChMNFa79U7LM91LmASrnlp0eVg3//3NZmSsEydfRPERrt4i
         MycODs1fx/Hol/Rv4t3BHgnSEAFsOq9y8ewBU=
Date: Fri, 8 Aug 2008 04:50:49 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Daryl Tester <dt-lkml@handcraftedcomputers.com.au>
Cc: Sven Wegener <sven.wegener@stealer.net>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM?: "permission denied" when accessing /proc/self/fd/*
	after setuid
Message-ID: <20080808005049.GA20707@martell.zuzino.mipt.ru>
References: <489A9357.50105@handcraftedcomputers.com.au> <alpine.LNX.1.10.0808071311300.16201@titan.stealer.net> <489B957D.9080206@handcraftedcomputers.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489B957D.9080206@handcraftedcomputers.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 10:08:21AM +0930, Daryl Tester wrote:
>>> The above environment isn't necessary to replicate the problem, although
>>> what stdout and stderr are attached to has some effect.  The attached C
>>> code replicates the issue, but appears to not fail (that is, succeed) if
>>> /proc/self/fd/2 is a terminal (e.g. /dev/pts/X) *and* that terminal is
>>> owned by the same uid that the code uses (in this case, 500). In the
>>> case of an anonymous pipe it appears to fail consistently as the pipe is
>>> owned by root.

Something similar was fixed in 2.6.22, but let me check.

