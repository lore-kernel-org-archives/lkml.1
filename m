Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbXLLItY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbXLLItY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 03:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756698AbXLLItG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 03:49:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:43098 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869AbXLLItC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 03:49:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Ae0Qmn1irMOeO3vM+/AyZkCbCbsrryHgIDxwPWjedkYx6c7a7252c1lI6xfIUMiLwlayD5H7hMS3YsditcccyuXwDwRNjKO0Pd/Y8SzwkTfZkTihw5zPlS43WXtF8GWqM4uMMeeMrISDddvxq2t3bZ1xd1KFkDQpAam1tYm96ZI=
Message-ID: <475FA071.1080201@gmail.com>
Date: Wed, 12 Dec 2007 13:48:49 +0500
From: "Alexander E. Patrakov" <patrakov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); ru-RU; rv:1.8.0.13pre) Gecko/20070505 Iceape/1.0.9 (Debian-1.0.11~pre071022-0etch1+lenny1) Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Anas Nashif <nashif@linux.intel.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       andi@firstfloor.org, davem@davemloft.net
Subject: Re: [PATCH] Intel Management Engine Interface
References: <475EC9C1.9080708@linux.intel.com>
In-Reply-To: <475EC9C1.9080708@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anas Nashif wrote:

> The Intel Management Engine Interface (aka HECI: Host Embedded 
> Controller Interface ) enables communication between the host OS and 
> the Management Engine firmware. MEI is bi-directional, and either the 
> host or Intel AMT firmware can initiate transactions.

There is a little problem: the driver doesn't work at all with the "64-bit 
kernel and 32-bit userspace" combination.

ioctl32(lms:7759): Unknown cmd fd(0) cmd(c0084800){t:'H';sz:8} arg(ffdfea44) on 
/dev/heci

Could you please fix it?

-- 
Alexander E. Patrakov
