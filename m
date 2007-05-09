Return-Path: <linux-kernel-owner+w=401wt.eu-S970125AbXEICoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970125AbXEICoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 22:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970044AbXEICoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 22:44:08 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:35509 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbXEICoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 22:44:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JwQ76kErH51hJI1YPaj6OhDddzsetGhR/NBbauuOLdxldd3ztCx1lTy+BN7Z0TuPI4uHsbv2BmheV3Mo+wpbeP0c5BxxV8+mAhXBW+MYw54gjdkxcWnAurUqkVPFSpvF0g4GfkXM8PJHLJUprO7dnJKE8jase0maftv7+C1IfYY=
Message-ID: <86802c440705081944v27e5311fp14974813dbd5adf2@mail.gmail.com>
Date: Tue, 8 May 2007 19:44:04 -0700
From: yhlu <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       vgoyal@in.ibm.com, "Gerd Hoffmann" <kraxel@redhat.com>,
       "Jeff Garzik" <jeff@garzik.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Andi Kleen" <ak@suse.de>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <m17irivkhy.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4634483E.9030307@goop.org>
	 <86802c440705081033s19365843i5b955ae175de73eb@mail.gmail.com>
	 <86802c440705081151r6bfd82e4o50c6a34b2b2a833f@mail.gmail.com>
	 <m1k5vji107.fsf@ebiederm.dsl.xmission.com>
	 <86802c440705081500x682ee098y7d51f7bb98dbcff6@mail.gmail.com>
	 <4640F4B3.30408@goop.org> <4640FB2C.2060300@zytor.com>
	 <86802c440705081541v7d0773cek2c5fae1854b68bbc@mail.gmail.com>
	 <46410403.4050802@zytor.com>
	 <m17irivkhy.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> I believe YH is asking how we setup real_mode_data in /sbin/kexec.

pxelinux:

SCREEN_INFO.orig_video_mode =  3
SCREEN_INFO.orig_x =  0
SCREEN_INFO.orig_y =  24
x86_boot_params[] :
0000: 00 18 ff ff 08 00 03 50 8c c8 03 00 8e c0 19 01
0010: 10 00 7c fb fc be 31 00 ac 20 c0 74 09 b4 0e bb
0020: 07 00 cd 10 eb f2 31 c0 cd 16 cd 19 ea f0 ff 00
0030: f0 44 69 72 65 63 74 20 62 6f 6f 74 15 00 10 00

current kexec:
SCREEN_INFO.orig_video_mode =  0
SCREEN_INFO.orig_x =  0
SCREEN_INFO.orig_y =  3
x86_boot_params[] :
0000: 00 03 00 fc 00 00 00 50 8c c8 00 00 8e c0 19 01
0010: 10 00 7c fb fc be 31 00 ac 20 c0 74 09 b4 0e bb
0020: 3f a3 00 16 eb f2 31 c0 cd 16 cd 19 ea f0 ff 00
0030: f0 44 69 72 65 63 74 20 62 6f 6f 74 15 00 20 00

YH
