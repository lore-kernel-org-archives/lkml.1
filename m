Return-Path: <linux-kernel-owner+w=401wt.eu-S1761505AbYA1Tmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761505AbYA1Tmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbYA1Tmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:42:46 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:20958 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbYA1Tmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:42:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=AkUsbwZ8xNir58qJod1xFneqpV10M+XGp5DiwgWD21mm71/hFipH3QwCbsatBKHezYanqmv6hDfMhp2FxmK5e7ESZzmnyWegnnqrgsy5NSwV32CxlK3AAWIMXqtpbt+Sq98/+0gWnqvQ3w3a/Aglt/JdDlnqWx0/4PpJVKXwPbo=
Date: Mon, 28 Jan 2008 22:42:20 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>, Jacob Shin <jacob.shin@amd.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH 2/5] x86: fix runtime error in
	arch/x86/kernel/cpu/mcheck/mce_amd_64.c
Message-ID: <20080128194220.GB6720@cvg>
References: <20080127233751.GA4524@kroah.com> <1201477122-4541-2-git-send-email-gregkh@suse.de> <20080128122434.GA24757@elte.hu> <20080128173706.GA17495@suse.de> <20080128175736.GC22487@elte.hu> <20080128183237.GA19829@suse.de> <20080128190149.GA24424@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128190149.GA24424@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Mon, Jan 28, 2008 at 08:01:49PM +0100]
| 
| * Greg KH <gregkh@suse.de> wrote:
| 
| > > Are kobjects protected against accidental copying? If not add &kobj 
| > > to the 'magic value' too, and check that - it becomes 
| > > copying-resistent that way and has the same cost to check. (which is 
| > > negligible anyway)
| > 
| > Oh, that's a very cool idea, I like it :)
| 
| hey, you are welcome :-)
| 
| [ I guess i should not mention that i've implemented list debugging for 
|   Linux that checksums the struct list contents and stores the checksum 
|   in it (offset by a magic value plus to address of the list head), and 
|   thus protects it against accidental corruption? It was capable of 
|   reliably detecting mixed up list_add() arguments for example, it 
|   detected list corruption of _every_ sort, it detected double
|   list_del() and list_add() of an already active list member as well. It
|   was even capable of detecting SMP races: two parallel unserialized
|   list_del()'s on the same list head were detected and warned about as 
|   well. I guess i should release it one of these days? =B-) ]
| 

did miss some words while reading this... ;)
really sorry, drop the mail i sent please

		- Cyrill -
