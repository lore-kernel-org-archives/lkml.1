Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbYDIT2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbYDIT2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 15:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbYDIT2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 15:28:41 -0400
Received: from gw.goop.org ([64.81.55.164]:52827 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648AbYDIT2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 15:28:41 -0400
Message-ID: <47FD18C5.6040709@goop.org>
Date: Wed, 09 Apr 2008 14:28:05 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080407)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Max Krasnyansky <maxk@qualcomm.com>,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC 1/5] vringfd syscall
References: <200804052202.09157.rusty@rustcorp.com.au>
In-Reply-To: <200804052202.09157.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> +asmlinkage long sys_vringfd(void __user *addr,
> +			    unsigned num_descs,
> +			    u16 __user *last_used)
> +{
> +	int fd, err;
> +	struct file *filp;
> +	struct vring_info *vr;
> +
> +	/* Must be a power of two, and representable by u16 */
> +	if (!num_descs || (num_descs & (num_descs-1)) || num_descs > 65536) {
>   

65536 doesn't fit in u16.

    J
