Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbYGILwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbYGILwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758123AbYGILwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:52:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:37330 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbYGILwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:52:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JKvoynj8rnFcn+SADeD0g6lDbTvX0muL/ZGgOsBDyphXkncckV8QgNmSn9SVJJdPuc
         WOutX4IC8Ij1/gZq5Z81YsBojAbnQ4PgEx4XzSJ32ZMOK0NarcFREY8N35apecwc8MZO
         FMVDnWcAq4TW2CPxHwACiZEHiw5lzsAcEWm80=
Message-ID: <bc64b4640807090452vc923216gfb14bb2c5974a61@mail.gmail.com>
Date: Wed, 9 Jul 2008 15:52:08 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: ian <spyro@f2s.com>
Subject: Re: [patch 4/4] MFD: Change mfd platform device usage to wrapper platform_device
Cc: "Ben Dooks" <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <1215603916.3295.57.camel@wirenth>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080709104916.200210922@fluff.org>
	 <20080709104933.101610936@fluff.org>
	 <bc64b4640807090415w781507fetfe332271ad158112@mail.gmail.com>
	 <1215603916.3295.57.camel@wirenth>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/9 ian <spyro@f2s.com>:
> On Wed, 2008-07-09 at 15:15 +0400, Dmitry wrote:
>> NAK.
>> 0) It was discussed yesterday on the list and the decision was to go
>> in a different way.
>
> It was?
>
> I prefer the wrapped way personally...

In any case IMO it's better to call platform_device_register() rather than
 device_initialise()/platform_device_add().

Samuel? Russell?

-- 
With best wishes
Dmitry
