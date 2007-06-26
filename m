Return-Path: <linux-kernel-owner+w=401wt.eu-S1759378AbXFZSzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378AbXFZSzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 14:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756852AbXFZSzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 14:55:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:30141 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277AbXFZSzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 14:55:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GdYvevdh0uNSnlzqy0KehFo6EmOW/lgWTOGcOEXMITeagEuchqdV51uIgj/8+4dtr6vOM8cywNohlCOwar/1ZlU3M0tA1isbkYdwX4mk7SooVHqfBTaw5B4oUlAHILck/pcjW5X1ClOTU5KuGH2QmkhOcclEffPW4qNInDmScJY=
Message-ID: <86802c440706261155y7339f87fp7acddae54bb0258@mail.gmail.com>
Date: Tue, 26 Jun 2007 11:55:43 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "Justin Piszcz" <jpiszcz@lucidpixels.com>
In-Reply-To: <20070626173806.GE5244@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706251434.43863.jesse.barnes@intel.com>
	 <20070625233433.GA32306@one.firstfloor.org>
	 <200706251636.53636.jesse.barnes@intel.com>
	 <m1bqf3tu06.fsf@ebiederm.dsl.xmission.com>
	 <20070626153911.GC5244@one.firstfloor.org>
	 <m1wsxqsnse.fsf@ebiederm.dsl.xmission.com>
	 <20070626173806.GE5244@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/07, Andi Kleen <andi@firstfloor.org> wrote:
> RevE had a new memory remapping scheme (memory hoisting) at least, which
> I think you refered to earlier.  There might have been more changes in F.

yes, REV E has hardware memory remapping.
Rev F you don't need to use mtrr to set MEM to WE above 4G.

YH
