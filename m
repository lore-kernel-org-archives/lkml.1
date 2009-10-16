Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbZJPIpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbZJPIpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 04:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbZJPIpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 04:45:33 -0400
Received: from dwdmx5.dwd.de ([141.38.3.242]:35785 "EHLO dwdmx5.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbZJPIpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 04:45:32 -0400
Date: Fri, 16 Oct 2009 08:44:50 +0000 (GMT)
From: Holger Kiehl <Holger.Kiehl@dwd.de>
X-X-Sender: kiehl@praktifix.dwd.de
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-raid <linux-raid@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Raid reconstructing and process hanging in D state
In-Reply-To: <alpine.DEB.2.00.0910160436160.2841@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0910160840400.2463@praktifix.dwd.de>
References: <Pine.LNX.4.64.0910160703260.2463@praktifix.dwd.de>
 <alpine.DEB.2.00.0910160436160.2841@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Oct 2009, Justin Piszcz wrote:
> Hi,
>
> I have the same problem with mdadm/raid-1, if you do not limit the speed in 
> the speed_limit_min paramter, it will starve the I/O from all other processes 
> and result in the same problem you are having.
>
But in my case speed_limit_min was set to 1000 and speed_limit_max was 200000
(ie. the default) and this still caused all process to hang in D-state. Only
lowering speed_limit_max helped to make the system responsive again.

> But for me I'm not sure about the reconstruction-- this happens for me during 
> a raid verify/check.
>
This was also the case for me, during a raid verify/check.

Holger
