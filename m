Return-Path: <linux-kernel-owner+w=401wt.eu-S1751359AbXEXQNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbXEXQNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 12:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750714AbXEXQMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 12:12:54 -0400
Received: from smtp-out.google.com ([216.239.33.17]:45343 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbXEXQMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 12:12:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=YQKgVBnJrQ6ulRL2SxfhLNRw9cEx0y21C0v+9QBopWKQtnIeYrL2rftXVfBD4rUBU
	PxGFqSer2UYHCddH+OP/g==
Message-ID: <6599ad830705240912q1d556c66xe239a9940fd8f373@mail.gmail.com>
Date: Thu, 24 May 2007 09:12:41 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH] Per container statistics
Cc: vatsa@in.ibm.com, linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru,
       akpm@linux-foundation.org, devel@openvz.org
In-Reply-To: <4655B668.2090306@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070514174454.15338.67171.sendpatchset@balbir-laptop>
	 <6599ad830705211356l9f2d24jc3a7834e7db34458@mail.gmail.com>
	 <4655B668.2090306@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
> I thought about this approach, but did not implement the code this way
> because a system could have thousands of containers and expecting a
> statistics application to open a file descriptor each time for each
> container will turn out to be an expensive operation
>
> overhead =  2 syscalls (open + close) * number of containers * frequency
>             of stats collections

But you can cache the file handles open between stats calls, assuming
you're doing them repeatedly.

Paul
