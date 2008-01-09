Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbYAIMdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbYAIMdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 07:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYAIMdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 07:33:14 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:42983 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbYAIMdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 07:33:13 -0500
Date: Wed, 9 Jan 2008 05:33:12 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: grant@torque.net, tim@cyberelk.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Change paride driver to use unlocked_ioctl instead of ioctl
Message-ID: <20080109123311.GP16309@parisc-linux.org>
References: <4785B7BC.5040106@suse.de> <4785C7D8.2020808@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4785C7D8.2020808@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 12:53:04PM +0530, Nikanth Karthikesan wrote:
>  	default:
>  		printk("%s: Unimplemented ioctl 0x%x\n", tape->name, cmd);
> +		unlock_kernel();
>  		return -EINVAL;

Surely a bug ... shouldn't this return -ENOTTY?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
