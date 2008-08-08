Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbYHHBKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbYHHBKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 21:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbYHHBKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 21:10:36 -0400
Received: from mail.lang.hm ([64.81.33.126]:53392 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbYHHBKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 21:10:35 -0400
Date: Thu, 7 Aug 2008 18:11:23 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: why are namespaces required?
In-Reply-To: <alpine.DEB.1.10.0808071752210.892@asgard.lang.hm>
Message-ID: <alpine.DEB.1.10.0808071809230.892@asgard.lang.hm>
References: <alpine.DEB.1.10.0808071752210.892@asgard.lang.hm>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2008, david@lang.hm wrote:

> I am taking the time to create a minimal config for some new hardware with 
> 2.6.25.15 and noticed that CONFIG_NAMESPACES is forced to Yes unless embeded 
> is selected (at which time it becomes configurable)
>
> why are namespaces required?

as a follow up, when enabling embedded mode, it defaults to everything 
enabled, including the option to 'disable heap randomization'

this should be changed to 'enable heap randomization' so that it can 
default to on line everything else (with the assumption being that mearly 
checking the option to be able to select the embeded menu doesn't change 
the kernel behavior, you would have to disable something in that menu)

David Lang
