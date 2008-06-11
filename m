Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbYFKPAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbYFKPAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751115AbYFKPAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:00:37 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:18273 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYFKPAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:00:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=ccc09CLGvMU4Vx0ll4v092JuIr2Y9d7JmBT7fEK/TU/z7kzEkLxk8LVk7PbF3mBTDP
         7abcGlMgtxZbg+iOVdvnFkTU1Jh+6SzUXV2vGiTMFp4VDBCr0gXejaBA7iLmjuE6zBMG
         N5ilNQj/6XPdoflrQZQPVK3IrVQky7z6zV3EM=
Message-ID: <7c86c4470806110800w465f1c91k7e8f0bb8fba18ca3@mail.gmail.com>
Date: Wed, 11 Jun 2008 17:00:34 +0200
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Greg KH" <greg@kroah.com>
Subject: Re: [patch 12/21] perfmon2 minimal: sysfs interface
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080611144955.GA20145@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <484daff1.1358560a.0808.0267@mx.google.com>
	 <20080611144955.GA20145@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On Wed, Jun 11, 2008 at 4:49 PM, Greg KH <greg@kroah.com> wrote:
> On Mon, Jun 09, 2008 at 03:34:25PM -0700, eranian@googlemail.com wrote:
>> +
>> +static struct kobject pfm_kernel_kobj;
>
> Eeek, no, please look at Documentation/kobject.txt that says to not ever
> have static kobjects.
>
Will do.

> I think a lot of this code can be cleaned up and shrunk given the way
> that kobjects have changed recently.  See the examples in
> samples/kobject/ and the documentation file for more details.
>
If you say so. When building the series, I also wondered why there was
so much code in there. But it was not clear to me how it could be shrunk.
I saw some simplifications in 2.6.26 but still a lot of small functions.

> If you have any questions about it, please let me know.
>
> Also, whenever you add a sysfs file to the kernel, please document it in
> Documentation/ABI/ so that everyone knows what it is and how to use it.
>

I have that in my GIT tree. I simply forgot to include them in the quilt series.
I will fix that.
