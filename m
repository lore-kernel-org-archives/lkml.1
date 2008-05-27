Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbYE0GnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbYE0GnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 02:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755610AbYE0Gmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 02:42:54 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:3657 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbYE0Gmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 02:42:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pB7/3kHUCqnNc4mgeNab4XigIrim4BpPJ7d3CJTHc3RqEMGNFLYrXsG4dJfST+MBaGBjh3M8mJzK3/g+LdKAec3TyBmLv/mclSFeQtUOp4drF+ZLQz3WqMzZzpH6Dc+5ZJ9FACY7nRtTbjoxisbRazZ3Jl6X/YAiwwIxPWEc5Ko=
Message-ID: <a8e1da0805262342g2dec037eqfdf376e66459e758@mail.gmail.com>
Date: Tue, 27 May 2008 14:42:51 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH 1/3][-mm] add class_reclassify macro
Cc: "Andrew Morton" <akpm@linux-foundation.org>, matthew@wil.cx,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <20080520172139.GA11666@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080520095553.GA3201@darkstar.te-china.tietoenator.com>
	 <20080520030232.fc91b64e.akpm@linux-foundation.org>
	 <20080520172139.GA11666@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 1:21 AM, Greg KH <greg@kroah.com> wrote:
> On Tue, May 20, 2008 at 03:02:32AM -0700, Andrew Morton wrote:
>> On Tue, 20 May 2008 17:55:54 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
>>
>> > Converting class semaphore to mutex cause lockdep warnings due to
>> > class_interface_register/unregister will possible call device_add/del
>>
>> Shouldn't we just fix that?
>
> Um, no, that's a "feature" that some types of hardware and interfaces
> require.
>
> This is one reason I really don't like this type of conversion, it's
> causing lots of problems for no known gain.
>
> So I would just recommend dropping this patch set, the current "convert
> class semaphore to a mutex" patch in the -mm tree is already causing
> lockdep warnings, and trying to do something like this isn't really
> going to solve the root problem here.

At last, I decide to give up.

Andrew, I could not do more for this issue now, you can drop the
conversion patch if there's no suitable fix from others.

Thanks
Dave
