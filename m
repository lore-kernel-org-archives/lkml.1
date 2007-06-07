Return-Path: <linux-kernel-owner+w=401wt.eu-S1764603AbXFGROS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764603AbXFGROS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757487AbXFGROJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:14:09 -0400
Received: from smtp-out.google.com ([216.239.45.13]:50426 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbXFGROI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:14:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=qVmNOrBG7mrpfmf6FdRPrTj9+dDPTDGyr5vBvSl4R+668ZUUjuSoy+WOVflAUUsf7
	mPFyd0LSVEJxXdnvQYwpg==
Message-ID: <6599ad830706071012u62963d4aqe2042d6af16c1c8@mail.gmail.com>
Date: Thu, 7 Jun 2007 10:12:19 -0700
From: "Paul Menage" <menage@google.com>
To: "Cedric Le Goater" <clg@fr.ibm.com>
Subject: Re: [PATCH 03/10] Containers(V10): Add tasks file interface
Cc: akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, balbir@in.ibm.com, pj@sgi.com, cpw@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, containers@lists.osdl.org
In-Reply-To: <46680F76.8020803@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070529130104.461765000@menage.corp.google.com>
	 <20070529132142.428218000@menage.corp.google.com>
	 <46680F76.8020803@fr.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/07, Cedric Le Goater <clg@fr.ibm.com> wrote:
>
> when there's no tasks in a container, opening
>
> <containerfs>/<container>/tasks
>
> spits the following warning because we are trying to
> kmalloc(0).

I guess I'm not opposed to this change - but isn't there still
discussion going on about whether kmalloc(0) should actually produce a
warning or not?

Thanks,

Paul
