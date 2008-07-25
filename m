Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbYGYRIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbYGYRIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 13:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYGYRIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 13:08:41 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:5919 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbYGYRIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 13:08:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WBYyL9r0Q9EgE53Q4IM+uqN/TMfZS5hWAf6RUQ1tvvPSvIi4/jfLzSs62hhb66aU8f
         EgbdA0S7gLun94kndFwyxPRtriBylJkedjQGZkTeKqw40rtmJ9jqGvWRJrpXtOtGAPnR
         cmyNrfluFKreKpCIRlzRHqcP6AMtug3I8Wmt4=
Message-ID: <91b13c310807251008o361bc39drfb6aa227cd9fd2f9@mail.gmail.com>
Date: Sat, 26 Jul 2008 01:08:38 +0800
From: "rae l" <crquan@gmail.com>
To: djwong@us.ibm.com
Subject: Re: [PATCH 2/5] drivers/scsi/aic94xx/: replace __FUNCTION__ with __func__
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080725164253.GA7355@tree.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216954114-31949-1-git-send-email-crquan@gmail.com>
	 <20080725164253.GA7355@tree.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 12:42 AM, Darrick J. Wong <djwong@us.ibm.com> wrote:
> On Fri, Jul 25, 2008 at 10:48:33AM +0800, Denis ChengRq wrote:
>> Signed-off-by: Denis ChengRq <crquan@gmail.com>
>
> No justification or changelog?
I think no more explanation needed, the subject is definite.

and no justification happened here, (there are justifications otherwhere)

>> -             __FUNCTION__)
>> +             __func__)
>
> include/linux/kernel.h:503:#define __FUNCTION__ (__func__)
This solution is not completely,

>
> I assume you're trying to kill this?
Eventually we will need a replace in the whole tree:

grep -RsInw __FUNCTION__ . |xargs sed -i -e 's/__FUNCTION__/__func__/g'
