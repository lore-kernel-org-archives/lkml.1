Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbZEDXdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbZEDXdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 19:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756306AbZEDXdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 19:33:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47737 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984AbZEDXdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 19:33:11 -0400
Message-ID: <49FF7B02.9050608@redhat.com>
Date: Mon, 04 May 2009 19:32:18 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Greg KH <greg@kroah.com>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, San Mehat <san@android.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: [patch 1/5] oom: cleanup android low memory killer
References: <alpine.DEB.2.00.0905031305130.18426@chino.kir.corp.google.com> <d6200be20905041448p1ca2d068r5ba8348488842b5c@mail.gmail.com> <20090504220905.GA29402@kroah.com> <alpine.DEB.2.00.0905041529570.2310@chino.kir.corp.google.com> <20090504225936.GA9876@kroah.com> <alpine.DEB.2.00.0905041607170.6073@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0905041607170.6073@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:

> There was an interest in a low mem userspace notifier that applications 
> can poll() on at configurable low mem levels to react accordingly.  This 
> would probably address the problem that the Android team is trying to fix.

This would also make it easier for virtual machines to be
ballooned down to size when the host experiences memory
pressure.

The low memory notification could also be useful for JVMs,
databases that do (some of) their own caching and any garbage
collected program in general.

-- 
All rights reversed.
