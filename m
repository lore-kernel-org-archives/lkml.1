Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbYCZPW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbYCZPW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbYCZPWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:22:19 -0400
Received: from smtp-out.google.com ([216.239.45.13]:49030 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbYCZPWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:22:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=GwMFUI9Au7dvT3S/zInv7vv7Vq4hkUE87MXAfEo2PXqpns2LcQxM69tU4u8RN9PpQ
	+jADvrQ/9DcRAxPkbIm6w==
Message-ID: <6599ad830803260821r5c5b56f3pd381659d0866c87b@mail.gmail.com>
Date: Wed, 26 Mar 2008 08:21:59 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC][-mm] Memory controller add mm->owner
Cc: linux-mm@kvack.org, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       "David Rientjes" <rientjes@google.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47EA3684.60107@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080324140142.28786.97267.sendpatchset@localhost.localdomain>
	 <6599ad830803240803s5160101bi2bf68b36085f777f@mail.gmail.com>
	 <47E7D51E.4050304@linux.vnet.ibm.com>
	 <6599ad830803240934g2a70d904m1ca5548f8644c906@mail.gmail.com>
	 <47E7E5D0.9020904@linux.vnet.ibm.com>
	 <6599ad830803241046l61e2965t52fd28e165d5df7a@mail.gmail.com>
	 <47E8E4F3.6090604@linux.vnet.ibm.com>
	 <47EA2592.7090600@linux.vnet.ibm.com>
	 <6599ad830803260420v236127cfydd8cf828fcce65bb@mail.gmail.com>
	 <47EA3684.60107@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 4:41 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
>  Hmmm.. the 99.9% of the time is just guess work (not measured, could be possibly
>  true). I see and understand your code below. But before I try and implement
>  something like that, I was wondering why zap_threads() does not have that
>  heuristic. That should explain my inhibition.
>
>  Can anyone elaborate on zap_threads further?
>

zap_threads() has to find *all* the other users, whereas in this case
we only have to find one other user.

Paul
