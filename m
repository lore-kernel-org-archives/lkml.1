Return-Path: <linux-kernel-owner+w=401wt.eu-S1757648AbZBPMtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648AbZBPMtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 07:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757395AbZBPMtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 07:49:40 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:53520 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbZBPMtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 07:49:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tsJs4vpHPnooPmbPKL3ur/LNW+tE18deL8Qdih/GjjqARC0wE872tiXkYfLumC6NjH
         R7bPPkc1aUNN8g5VId4WbQA3dfu3ymgy4+aubtqbjr122gKCAgkGDsp27oIHTd7XZsUl
         +G02XBcMabMXbVRlbsfprpSyliDe1WVNyXaGU=
Date: Mon, 16 Feb 2009 20:49:39 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Luca Bigliardi <shammash@artha.org>, trivial@kernel.org,
       linux-kernel@vger.kernel.org, jdike@addtoit.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix vde network backend in user mode linux
Message-ID: <20090216124939.GC23665@hack.private>
References: <20090202172822.GA2801@pintsize> <alpine.LNX.1.10.0902161334250.18110@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0902161334250.18110@jikos.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 01:38:46PM +0100, Jiri Kosina wrote:
>
>[ doesn't seem to be picked up by anyone into current -next nor -mmotm, 
>  but isn't appropriate for trivial; adding akpm to cc ]
>
>On Mon, 2 Feb 2009, Luca Bigliardi wrote:
>
>> * Replace kmalloc() with uml_kmalloc()
>>   (fix build failure)


Weird... I sent a patch for this several months ago! I thought
Jeff had already taken it... No?


>> * Remove unnecessary UM_KERN_INFO in printk()
>>   (don't display '<6>' while printing info)

But why only this one, not other UM_KERN_INFO in the same file?


-- 
"Against stupidity, the gods themselves, contend in vain."

