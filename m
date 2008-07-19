Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbYGSNTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbYGSNTV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 09:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbYGSNTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 09:19:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:11450 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbYGSNTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 09:19:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=J4wThedWi7qZHVsFhxAwMLsd6UNS9pzFRJA6LoyjzVo/67lVR9iN3Rgmmdx1Zto2v8
         jBGfPsYCa7mkXCPFCiXbFUqf6/+s+YMqEdVuupEilXTBXBVKpMm5u+bkLg7JpO7Yddwu
         qyjolPnz4yHegMoCjQgl/KPYJjoGmtjXw1ON0=
Date: Sat, 19 Jul 2008 17:19:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfs: use kstrdup()
Message-ID: <20080719131909.GB7027@asus>
References: <4881BEF4.2020201@cn.fujitsu.com> <20080719131317.GA7027@asus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080719131317.GA7027@asus>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sat, Jul 19, 2008 at 05:13:17PM +0400]
[...]
| | -			}
| | -		}
| | +		mnt->mnt_devname = kstrdup(name, GFP_KERNEL);
| |  	}
| |  	return mnt;
| |  }
| | -- 
| | 1.5.4.rc3
| | 
| | 
| 
| but kstrdup may return NULL - is it safe there?
| Sorry if that "not smart" question.
| 
| 		- Cyrill -

ah, I see it is safe - sorry for noise

		- Cyrill -
