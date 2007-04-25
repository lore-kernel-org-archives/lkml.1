Return-Path: <linux-kernel-owner+w=401wt.eu-S2992704AbXDYLgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992704AbXDYLgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 07:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992721AbXDYLgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 07:36:49 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:38906 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992704AbXDYLgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 07:36:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding:sender;
        b=qRj1+s2dkIzQSsguEEF6NVJ8i+JCwr8K+1zsA9ayaoj5kMMBjjX06yzuTYxINqFWJ9CqnbbG56d2LhksPRa7BQ4TGXuIiHTpJ5jO8ifgdPWkrF19Ps8JzA68GV2vVF0qtigsWTEJ5adkB1NmKAND2GOf7dc5iJRbAygkr/KcW+s=
Subject: Re: [PATCH] IPROUTE: Modify tc for new PRIO multiqueue behavior
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       cramerj@intel.com, auke-jan.h.kok@intel.com,
       christopher.leech@intel.com, davem@davemloft.net
In-Reply-To: <462ED398.5080405@linux-foundation.org>
References: <20070425013920.6031.30149.stgit@gitlost.site>
	 <462ED398.5080405@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 25 Apr 2007 07:36:43 -0400
Message-Id: <1177501003.4082.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-24-04 at 21:05 -0700, Stephen Hemminger wrote:
> Peter P Waskiewicz Jr wrote:

> Only if this binary compatiable with older kernels.

It is not. But i think that is a lesser problem, the bigger question is:
Why would you need to change a qdisc just so you can support egress
multiqueues?

BTW, is there any reason this is being cced to lkml?

cheers,
jamal

PS:- I havent read the kernel patches (i am congested and about 1000
messages behind on netdev) and my opinions may be influenced by an
approach i have in trying to help someone fixup a wireless driver with
multiqueue support.

