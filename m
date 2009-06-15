Return-Path: <linux-kernel-owner+w=401wt.eu-S1759162AbZFOKhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759162AbZFOKhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 06:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbZFOKg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 06:36:59 -0400
Received: from mail-fx0-f206.google.com ([209.85.220.206]:34968 "EHLO
	mail-fx0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbZFOKg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 06:36:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eYhceH39J152lDkdfxjbmLoSQ4Fb/OtM6oBhELjcSiUh/57qpfbT0meQOyBWBFdYue
         fzU6rdCpSiJbQclRxopDjn+a3squfbII+dZBA9+zOicMCpDo7/IqLlmSt82dHVU09HHA
         uWsSOJUstMAPQHC8ApsIl0b8lDZQlSG5opPnQ=
MIME-Version: 1.0
In-Reply-To: <20090615103145.GB20461@wotan.suse.de>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
	 <20090615081831.GA5411@osiris.boeblingen.de.ibm.com>
	 <20090615082636.GA30964@wotan.suse.de>
	 <1245054779.23207.6.camel@penberg-laptop>
	 <20090615085209.GB30964@wotan.suse.de>
	 <1245056919.23207.7.camel@penberg-laptop>
	 <20090615102004.GB5411@osiris.boeblingen.de.ibm.com>
	 <1245061304.23207.21.camel@penberg-laptop>
	 <20090615103145.GB20461@wotan.suse.de>
Date: Mon, 15 Jun 2009 13:36:59 +0300
X-Google-Sender-Auth: 5c94daa89ae6d872
Message-ID: <84144f020906150336q66b81ee9u22f84b688ace344f@mail.gmail.com>
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, yinghai@kernel.org,
       benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 1:31 PM, Nick Piggin<npiggin@suse.de> wrote:
> Recent change to use slab allocations earlier exposed a bug where
> SLUB can call schedule_work and try to call sysfs before it is
> safe to do so.
>
> Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: Nick Piggin <npiggin@suse.de>

Applied, thanks!
