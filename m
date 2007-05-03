Return-Path: <linux-kernel-owner+w=401wt.eu-S1031103AbXECJhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031103AbXECJhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 05:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031059AbXECJhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 05:37:51 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:35850 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031000AbXECJhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 05:37:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aVtHv8vWWIYJ+O4/Oi6Lzt9Z/MzPRhkcv1NQ/mxaZlbiB0DsR/zDxwSLymoOMKHhZuFrzxezBev7iqHAL2aR/ZiIRIj3aeVgM2o1Vk+cSYOI28OAAdZm3HME2MwQdqNKCNeQeK3PJ9OkKRXKHOzsHqhI9TPpdyauYy/oKFoqv9w=
Message-ID: <a781481a0705030237l7d636b55t93f2ee5151cd7709@mail.gmail.com>
Date: Thu, 3 May 2007 02:37:20 -0700
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: finding your own dead "CONFIG_" variables
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705030400120.20539@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705030400120.20539@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> http://fsdev.net/wiki/index.php?title=Dead_CONFIG_variables

> kcfiles=$(find . -name "Kconfig*")

Suggest: configfiles=$(find . -name 'Kconfig*' -or -name '*defconfig*')

Some CONFIG_ options exist that are not declared anywhere in the
Kconfig files but defined directly in the arch/.../*defconfig* files.
