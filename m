Return-Path: <linux-kernel-owner+w=401wt.eu-S1758811AbYEJXCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811AbYEJXCP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 19:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755252AbYEJXB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 19:01:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:47809 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbYEJXB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 19:01:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NKQx598BD7iJfwu/aDAZr528wiLJx8OI6dkfeTMhD7JByAGqwn9CHlz9dSpx2hGGoNx8LMis4OBHWwFd/CnKfHsHMyrRB2zVUHNW1vhvpwV9oeK//ERj0vQ8ZqZ7YsHokO2dRBTggLrCC9xx4IfBDIFwP/sl8hiOaKDwJyRroOM=
Message-ID: <86802c440805101601h8591418t3d728e61ea4a1332@mail.gmail.com>
Date: Sat, 10 May 2008 16:01:57 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: lsscsi is broken
Cc: dougg@torque.net,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Greg KH" <greg@kroah.com>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       Linux-Scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <20080510223643.GO19219@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440805091638q59031edbifa439344acf0c971@mail.gmail.com>
	 <4825EAA0.5030305@torque.net>
	 <86802c440805101306w64b5c72dn4dbfea74a6557c2f@mail.gmail.com>
	 <20080510211904.GN19219@parisc-linux.org>
	 <86802c440805101522l3cec5089he5d077fdee698cea@mail.gmail.com>
	 <20080510223643.GO19219@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2008 at 3:36 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Sat, May 10, 2008 at 03:22:31PM -0700, Yinghai Lu wrote:
>> will look at it monday or later.
>>
>> don't want to keep on booting my laptop.
>>
>> or my .config has some setting problem? it could be duplicated on all
>> my test servers
>
> Could be "# CONFIG_SYSFS_DEPRECATED is not set".  I have no idea what
> that controls, but /sys/bus/scsi/devices could be one thing.
>
looked at last config for 2.6.25, the SYSFS setting in CONFIG is the
same as the one for current git.

YH
