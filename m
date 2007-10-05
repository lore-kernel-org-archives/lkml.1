Return-Path: <linux-kernel-owner+w=401wt.eu-S1759248AbXJECqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248AbXJECqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 22:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXJECqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 22:46:05 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:51638 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbXJECqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 22:46:04 -0400
Date: Thu, 4 Oct 2007 20:46:02 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] isofs: add +w bit for non-RR discs
Message-ID: <20071005024602.GU12049@parisc-linux.org>
References: <Pine.LNX.4.64.0710021958230.7130@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710021958230.7130@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 08:00:26PM +0200, Jan Engelhardt wrote:
> Add %S_IWUGO bit for files on ISO-9660 filesystems without RockRidge

Looks to me like you've added S_IWUSR, not S_IWUGO.

> -	popt->mode = S_IRUGO | S_IXUGO; /*
> +	popt->mode = S_IRUGO | S_IWUSR | S_IXUGO;
> -		inode->i_mode = S_IRUGO | S_IXUGO | S_IFDIR;
> +		inode->i_mode = S_IRUGO | S_IWUSR | S_IXUGO | S_IFDIR;

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
