Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886Ab0AGTkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab0AGTkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866Ab0AGTkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:40:08 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:53488 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab0AGTkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:40:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=ve5dYO/o5ki3KElOYH4lVbJzi9qi0cm0jFqCaQHWQiqeJZTZdB767+uYaIbNvIBNEq
         UProYzEMsWH7ezMrJgEsxmtgsAeKmyrSLnZSzQmG2TSifChWYS4kwUlgSzwM4OMSeYrp
         HPEskrs6UnWwrzcBEVXGWpM9he9Lasx+CpEXk=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bastian Blank <waldi@debian.org>
Subject: Re: [PATCH 2/7] Input: wacom - Get features from driver info
Date: Thu, 7 Jan 2010 11:39:50 -0800
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc3; KDE/4.3.4; x86_64; ; )
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ping Cheng <pingc@wacom.com>
References: <20100107182553.GA11236@wavehammer.waldi.eu.org> <201001071106.31688.dmitry.torokhov@gmail.com> <20100107192105.GA15015@wavehammer.waldi.eu.org>
In-Reply-To: <20100107192105.GA15015@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Message-Id: <201001071139.50766.dmitry.torokhov@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 January 2010 11:21:05 am Bastian Blank wrote:
> On Thu, Jan 07, 2010 at 11:06:30AM -0800, Dmitry Torokhov wrote:
> > On Thursday 07 January 2010 10:29:36 am Bastian Blank wrote:
> > > +	struct wacom_features *features = (void *)id->driver_info;
> >
> > What is this cast for?
> 
> driver_info is an integer.
> 
> > > +	if (!features)
> > > +		features = get_wacom_feature(id);
> >
> > In which cases driver would not have driver_info set up?
> 
> At this stage in the patchset, non have. Later the driver defined ids
> have, the user defined have not.
> 

Ah, OK.  Frankly I would fold patches 2-7 into one since it is one logical 
change. While you are at it, any chance of constifying wacom_features?

Thanks.

-- 
Dmitry
