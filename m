Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbZCDG6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbZCDG6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 01:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZCDG55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 01:57:57 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:63828 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbZCDG55 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 01:57:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qZAtiMUEL7GTpuQbezLko+0Eq5rH6IWkMwFAj1qkGnc74HSR4bLsJWL1NjFLscE2Tr
         tYzuQ+Ox86iJ9ML5EzdVWa0HzK71g36k6dCj0Rd6iLcgGXq5IjBll35jywGqzX47QDgq
         e/fzbDG55ZJgFBAuvgMw13TNZ2Y8rlcUp4uAU=
MIME-Version: 1.0
In-Reply-To: <49ADE201.7010506@kernel.org>
References: <86802c440903031458p4a72f8c8x6f91e9f58ac6bc26@mail.gmail.com>
	 <86802c440903031751y136b506uc163dd2c9023de9b@mail.gmail.com>
	 <49ADE201.7010506@kernel.org>
Date: Tue, 3 Mar 2009 22:57:54 -0800
X-Google-Sender-Auth: 2e32907714c103bb
Message-ID: <86802c440903032257l6607972dqe2390958b18454bd@mail.gmail.com>
Subject: Re: 32bit panic on 4 sockets
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 3, 2009 at 6:05 PM, Tejun Heo <tj@kernel.org> wrote:
> Looks like a genuine bootmem bug.  Cc'ing Johannes and
> quoting whole body.

it is x86 32bit numa code problem. it assume bootmem will sit on first
node only.

YH
