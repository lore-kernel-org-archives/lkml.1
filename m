Return-Path: <linux-kernel-owner+w=401wt.eu-S932950AbYCFVGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbYCFVGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbYCFVFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:05:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44795 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbYCFVFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:05:54 -0500
Message-ID: <47D05CA0.9080305@zytor.com>
Date: Thu, 06 Mar 2008 13:05:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pawel Plociennik <paplociennik@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
References: <200803060001.38432.paplociennik@gmail.com> <47CF79E4.3030107@zytor.com> <20080306102712.GE13391@elte.hu> <47D00B16.6040004@zytor.com> <20080306205736.GA22756@elte.hu>
In-Reply-To: <20080306205736.GA22756@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> It's useless because it's exactly and trivially replaceable with:
>>
>> 	init=/path/to/any/sbin/chroot /newroot /sbin/init
> 
> ok, i didnt realize that this was possible. Ah ... i see, 
> init/main.c:init_setup() is special and picks the whole boot parameter 
> string up to the end, right? So init= is the only multi-parameter 
> init-parameter.
> 

Actually, any parameters without = get passed as arguments to init.

	-hpa
