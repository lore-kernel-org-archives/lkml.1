Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbYE2JF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbYE2JF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 05:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYE2JFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 05:05:11 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:47773 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752972AbYE2JFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 05:05:09 -0400
Message-Id: <1212051908.8215.1255644495@webmail.messagingengine.com>
X-Sasl-Enc: JkYl3Vk4+dq3QaNAcvbnxGLyyZG8GQi0yflelNK1VGah 1212051908
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Dave Airlie" <airlied@gmail.com>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "dri-devel" <dri-devel@lists.sourceforge.net>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <21d7e9970805281746k71b47ed2i79c06288d2dca022@mail.gmail.com>
Subject: Re: in-kernel DRM tree move around....
In-Reply-To: <21d7e9970805281746k71b47ed2i79c06288d2dca022@mail.gmail.com>
Date: Thu, 29 May 2008 11:05:08 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 10:46:22 +1000, "Dave Airlie" <airlied@gmail.com>
said:
> Hi,
> 
> So I've been growing more annoyed with the current layout of the drm
> tree in the kernel,
> 
> a) it lives under char.
> b) everything in one directory.
> c) header files in one directory.
> d) no header files exposed to userspace.
> 
> http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commitdiff;h=7df9a948d0f849466e3de259cccb49bc54cbad68
> 
> is a proposal to create drivers/gpu/drm, (I may move AGP in there as
> well later). It also creates per-driver subdirs.

Looks like a lot more suitable place! I just wonder if drivers/video/drm
would be even more logical?

Greetings,
    Alexander

> This to me solves the a-d problems.
> 
> There is also an out-of-tree kernel drm which I'll probably give some
> more thought later.
> 
> Dave.
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Does exactly what it says on the tin

