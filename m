Return-Path: <linux-kernel-owner+w=401wt.eu-S1752710AbYLPIZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbYLPIZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 03:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbYLPIZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 03:25:33 -0500
Received: from smtp-out.google.com ([216.239.45.13]:22319 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYLPIZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 03:25:32 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=anj8otkP4wEaOIcVeQtZQlAcfIYwHCrfTtZ8FDGpQcOe4MLKZAq8K6cD8zv+5edDi
	HX/h9gXSEOn1xUAf/bq1A==
MIME-Version: 1.0
In-Reply-To: <4947389D.1050708@cn.fujitsu.com>
References: <4947389D.1050708@cn.fujitsu.com>
Date: Tue, 16 Dec 2008 00:25:27 -0800
Message-ID: <6599ad830812160025p17269c26id3c6678d4e7d847e@mail.gmail.com>
Subject: Re: Why are the pages not migrated to current cpuset after 
	'memory_migrate' is set true
From: Paul Menage <menage@google.com>
To: miaox@cn.fujitsu.com
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 9:11 PM, Miao Xie <miaox@cn.fujitsu.com> wrote:
> I found the pages that task had allocated to it on nodes in its previous cpuset
> were not migrated to the tasks' current cpuset after 'memory_migrate' was set
> true. It looks strange for users. Why are the pages not migrated to current
> cpuset after 'memory_migrate' is set true?
>
> Step I did
> 1, allocate pages on cpuset (mems is 0, memory_migrate is 0)
> 2, change cpuset's mems (mems: 0 -> 1)
> 3, change cpuset's memory_migrate(memory_migrate: 0 -> 1)

As Daisuke says, migration only occurs when the mems file is changed
*after* memory_migrate has been set to 1.

Paul
