Return-Path: <linux-kernel-owner+w=401wt.eu-S1756445AbXGVIG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbXGVIG2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 04:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbXGVIGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 04:06:02 -0400
Received: from smtp-out.google.com ([216.239.45.13]:10691 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913AbXGVIFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 04:05:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=uOh1fhDhG950G/dlt/tNVVRHlGPmCkCgsfm4T5qEYdg2blgcyxYHD5g25p27NEIqm
	UAzYLbgtM4gpsJC7bR3IQ==
Date: Sun, 22 Jul 2007 01:05:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86_64: offset apicid_to_node before use it before
 init_cpu_to_node
In-Reply-To: <86802c440707211749x3258891fhbb72a155dc484e86@mail.gmail.com>
Message-ID: <alpine.DEB.0.99.0707220104550.6665@chino.kir.corp.google.com>
References: <86802c440707211749x3258891fhbb72a155dc484e86@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007, Yinghai Lu wrote:

> [PATCH 3/3] x86_64: offset apicid_to_node before use it before
> init_cpu_to_node
> 

Does this preserve the correct fake apicid_to_node mapping for the 
emulated case such as numa=fake=32?
