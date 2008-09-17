Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbYIQXg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbYIQXg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 19:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbYIQXgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 19:36:48 -0400
Received: from smtp-out.google.com ([216.239.33.17]:14867 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbYIQXgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 19:36:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=XGIzZ8DXsyCvF0Z1VOsZ/TJUcFMu58Ex1Kp5E14VL215CpV8csutVUF6YdQbVcOVN
	DtGCD+ZiqnkMo8pl5I+qQ==
Message-ID: <6599ad830809171636s6f31cac9q90571d2ee71c9e2b@mail.gmail.com>
Date: Wed, 17 Sep 2008 16:36:40 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH] Fix declaration of cgroup_mm_owner_callbacks
Cc: "Andrew Morton" <akpm@linux-foundation.org>, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org
In-Reply-To: <48D176EA.9040304@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080915190638.99E613D6952@localhost>
	 <20080917142714.a822ac1a.akpm@linux-foundation.org>
	 <48D176EA.9040304@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 2:30 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>
>> Being too lazy to go back and find out what "something" is, I assumed
>> that this isn't needed in 2.6.27.
>
> We don't have anything using CONFIG_MM_OWNER in 2.6.27, so we should be OK
> pushing this to 2.6.28 (Pekka plans to use it for revoke* calls).
>
> Pekka, Paul do you agree?
>

Yes, there's no rush for this.

Paul
