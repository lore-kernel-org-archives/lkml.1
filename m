Return-Path: <linux-kernel-owner+w=401wt.eu-S968502AbXEHWlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968502AbXEHWlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968498AbXEHWlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:41:06 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:12315 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967563AbXEHWlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:41:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eD94H/4lNsGuYaqEZTisptqUeypxgOX6jpzvwSe1BYvkVC04pEIuG27+bHRgs94g1cYCqDHWRHX9uGpfuCvUm3um8guR3YneVfcMSjfIYSQP6amH9nu5UJBlCMawAUitBkPqctVgBiDQUOcy5yGNyon1jxEOsj4jJyqwyJcIHoE=
Message-ID: <86802c440705081541v7d0773cek2c5fae1854b68bbc@mail.gmail.com>
Date: Tue, 8 May 2007 15:41:01 -0700
From: yhlu <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, vgoyal@in.ibm.com,
       "Gerd Hoffmann" <kraxel@redhat.com>, "Jeff Garzik" <jeff@garzik.org>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <4640FB2C.2060300@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4634483E.9030307@goop.org>
	 <m1tzuuv24z.fsf@ebiederm.dsl.xmission.com>
	 <86802c440705080941y69ddd5d6lab170c5f3967f148@mail.gmail.com>
	 <m1sla7i68s.fsf@ebiederm.dsl.xmission.com>
	 <86802c440705081033s19365843i5b955ae175de73eb@mail.gmail.com>
	 <86802c440705081151r6bfd82e4o50c6a34b2b2a833f@mail.gmail.com>
	 <m1k5vji107.fsf@ebiederm.dsl.xmission.com>
	 <86802c440705081500x682ee098y7d51f7bb98dbcff6@mail.gmail.com>
	 <4640F4B3.30408@goop.org> <4640FB2C.2060300@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Jeremy Fitzhardinge wrote:
> Specifically boot_params.screen_info isn't being properly set up by the
> caller.

 will setup real_mode_data in kexec path?

YH
