Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbZJVTw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbZJVTw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 15:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbZJVTw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 15:52:28 -0400
Received: from smtp-out.google.com ([216.239.45.13]:62101 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597AbZJVTw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 15:52:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=t5tRgUQuqndOOKd/6Ykje0Urj+qkH8BdcF2T7Vz0XqYSmB1b7M1vFvZkm9ZyLxLt/
	0amdJhU0lEiO9TRsHq1cA==
Date: Thu, 22 Oct 2009 12:52:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alex Chiang <achiang@hp.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/5] mm: add numa node symlink for cpu devices in
 sysfs
In-Reply-To: <20091022041525.15705.6794.stgit@bob.kio>
Message-ID: <alpine.DEB.2.00.0910221252020.26631@chino.kir.corp.google.com>
References: <20091022040814.15705.95572.stgit@bob.kio> <20091022041525.15705.6794.stgit@bob.kio>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Oct 2009, Alex Chiang wrote:

> You can discover which CPUs belong to a NUMA node by examining
> /sys/devices/system/node/node#/
> 
> However, it's not convenient to go in the other direction, when looking at
> /sys/devices/system/cpu/cpu#/
> 
> Yes, you can muck about in sysfs, but adding these symlinks makes
> life a lot more convenient.
> 
> Signed-off-by: Alex Chiang <achiang@hp.com>

Acked-by: David Rientjes <rientjes@google.com>
