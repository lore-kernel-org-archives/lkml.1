Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbYGGHGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbYGGHGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 03:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbYGGHFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 03:05:47 -0400
Received: from smtp-out.google.com ([216.239.33.17]:33981 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbYGGHFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 03:05:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=GZ7y0xEwi0Dt1q/Vh766Yw02WZbNErtpD8RzXwX4vPDGvDk9puvoLI7FiCF1c74U1
	RAsuY9+d6UmNll0ity5bg==
Date: Mon, 7 Jul 2008 00:05:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: John Blackwood <john.blackwood@ccur.com>
cc: linux-kernel@vger.kernel.org, Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Joe Korty <joe.korty@ccur.com>
Subject: Re: [bug ?] do_get_mempolicy()
In-Reply-To: <alpine.DEB.1.10.0807031440170.17955@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0807070004500.30870@chino.kir.corp.google.com>
References: <486D3A4A.6000502@ccur.com> <alpine.DEB.1.10.0807031440170.17955@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2008, David Rientjes wrote:

> You're right, the flags member of struct mempolicy has subsequently 
> changed to carry "internal" flags that are not supposed to be exposed to 
> userspace via the get_mempolicy() API.
> 

John, please give 2.6.26-rc9 a try and let me know if there's any 
outstanding issues.

Thanks.
