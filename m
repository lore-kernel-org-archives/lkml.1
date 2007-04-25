Return-Path: <linux-kernel-owner+w=401wt.eu-S1030840AbXDYBMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030840AbXDYBMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 21:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030859AbXDYBMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 21:12:36 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:41877 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030840AbXDYBMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 21:12:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ir4aV+ODY9tq6ZUS1WfQ+/L4ArsXO7cu3t0ipa1yDP5Tf3KdGQ8jIvmn1RosbVAIZO58Z5JcNowspBr2n4dF/U7pjJvkWyYNGuCZdDcfRxzNIJRRQSKy6toXxVA7+DS8kN/rkAv24thSqee30UWcrWhvK4iIFY8O9Em1VcddtgI=
Message-ID: <2c0942db0704241812m72e02611sc41f83c1b89629be@mail.gmail.com>
Date: Tue, 24 Apr 2007 18:12:33 -0700
From: "Ray Lee" <madrabbit@gmail.com>
Reply-To: ray-gmail@madrabbit.org
To: "Greg KH" <greg@kroah.com>, "Adrian Bunk" <bunk@stusta.de>,
       "Wolfgang Erig" <Wolfgang.Erig@gmx.de>
Subject: Re: regression with gammu on 2.6.21-rc7
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070425001356.GB1183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070420085853.GA5594@erig.dyndns.org>
	 <20070423054717.GB17997@kroah.com>
	 <20070423081022.GA25694@erig.dyndns.org>
	 <20070425001356.GB1183@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/07, Greg KH <greg@kroah.com> wrote:
> Also, if you know how to use git, doing a 'git bisect' to try to track
> down the problem commit would be very helpful.

Has to do with SIGIO, see this blog post:

http://blog.cihar.com/archives/2007/04/24/kernel_2_6_21_hits_gammu/

Ray
