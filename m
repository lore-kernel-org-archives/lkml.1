Return-Path: <linux-kernel-owner+w=401wt.eu-S932821AbXAXWjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821AbXAXWjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 17:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932831AbXAXWjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 17:39:49 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:8462 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932821AbXAXWjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 17:39:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pxJSeKE4jcBtr32HY3zwqWtkBBGyWyJfd57kfBH4xRMZWVCN2nVFWlL1WEsRY9xCF0UIxrIeKEc6/bBJ/y2j+QlEuiTsEdJp3SzLuWmecuxLEMoatcmF7CKbmnBFUv7EldVS08hp5M52t31Dc2HkF5Si1HZpw/2NUjRQmPVPybQ=
Message-ID: <21d7e9970701241439y1431254bwf088f9f3043dd0c@mail.gmail.com>
Date: Thu, 25 Jan 2007 09:39:47 +1100
From: "Dave Airlie" <airlied@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: gpu sharing layer for kernel
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org
In-Reply-To: <20070124214654.GA30634@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1169637623985-git-send-email-airlied@linux.ie>
	 <20070124214654.GA30634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Why do we want this?
> >
> > Currently the kernel cannot provide both the fb and drm drivers with
> > access to the device model and this means the drm cannot get any
> > suspend/resume callbacks.  This layer attempts to fix this problem by
> > adding a bus for the gpu drivers to attach to. Currently a lowlevel
> > binding driver is needed along with optional fb and drm components.
>
> If we were to allow this kind of "sharing" for all PCI devices would
> that work out instead?  Or would this layer still be needed?

Initially this layer wouldn't be needed, but I'd like to add some
awareness to the drivers, so the drm can tell the fb to stop doing
stuff and vice-versa if necessary....  but perhaps that could be done
with a generic layer also.. or via the lowlevel driver I have...

Dave.
