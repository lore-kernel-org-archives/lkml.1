Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbYHZUwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbYHZUwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbYHZUwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:52:13 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:11384 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbYHZUwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:52:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=H535RrM5Kgq6qVxmfv1e5bChOxOEg8TW8u4ZYfIlqjLA9EAk5oil5RBeM02EdOq0P6
         VMfP1YO2ihvTq4iQpZmulMg/F5SzmmSfSOYwn2A/r7u5N4NsqH2h10AbDFznoZYomd11
         dwKyqXJSMvvz2LEAc9VOabMe6TugPzhTFdJVo=
Subject: Re: [PATCH 1/2] rcu: spinlocks take an unsigned long flags
From: Harvey Harrison <harvey.harrison@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080826204534.GJ6656@linux.vnet.ibm.com>
References: <1219780844.6069.5.camel@brick>
	 <20080826204534.GJ6656@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 26 Aug 2008 13:52:11 -0700
Message-Id: <1219783931.6069.31.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-26 at 13:45 -0700, Paul E. McKenney wrote:
> On Tue, Aug 26, 2008 at 01:00:44PM -0700, Harvey Harrison wrote:
> > Noticed by sparse:
> > kernel/rcuclassic.c:719:2: error: incompatible types in comparison expression (different signedness)
> > kernel/rcuclassic.c:727:2: error: incompatible types in comparison expression (different signedness)
> > kernel/rcuclassic.c: In function ‘rcu_init_percpu_data’:
> > kernel/rcuclassic.c:719: warning: comparison of distinct pointer types lacks a cast
> > kernel/rcuclassic.c:727: warning: comparison of distinct pointer types lacks a cast
> 
> This is a duplicate of http://lkml.org/lkml/2008/8/18/497, sent in
> by Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>.
> 

Ok, what tree is it going in through, this was from today's linux-next.

Harvey

