Return-Path: <linux-kernel-owner+w=401wt.eu-S1757635AbYDROoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbYDROoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 10:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757238AbYDROoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 10:44:00 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:46653 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178AbYDROn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 10:43:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=fMSxZadSmbNkxGy66o9i6MzFkXALjyEpTyY7p96OvCNouuHjLo4VoKU0y6t2TFdWT2gL6zQXk2Uv4FJXshGGpSlNmCsfXwrJJ6fG5kMDSJAaMXq5uW0i+t1HfnnBt5zDSRx1h71/rIqT4IRVq32orxwsDWUlgu/BZF38KptqdEw=
Message-ID: <b6c5339f0804180743h6f3915c7tf08ed6cb920a152f@mail.gmail.com>
Date: Fri, 18 Apr 2008 10:43:57 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Cc: szaka@ntfs-3g.org, hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <E1JmrUk-00062E-FU@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com>
	 <20080412205544.5e12a7d4.akpm@linux-foundation.org>
	 <20080413080130.GA9622@infradead.org>
	 <20080413012001.8d7967f4.akpm@linux-foundation.org>
	 <20080413082815.GA20108@infradead.org>
	 <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>
	 <20080414004521.GA30489@hash.localnet>
	 <Pine.LNX.4.61.0804181302180.29728@dhcppc2>
	 <b6c5339f0804180651m2a291755ke093bda3bea1d2b4@mail.gmail.com>
	 <E1JmrUk-00062E-FU@pomaz-ex.szeredi.hu>
X-Google-Sender-Auth: ebafda807dfbb5b9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 10:23 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>  Fuse has two different APIs.  For the "high level", path based one,
>  this is true.  The "low level" one is very similar to the one provided
>  by the VFS.

Ah nice, I do not know how I missed that.  Thanks for pointing that out.

>  And I think the VFS is great.  Undoubtedly kernel programming has it's
>  own charm, and I definitely don't want to scare you away from that.
>  Merging into mainline is a great reward, which must be erned the hard
>  way.  The debate is just part of that ;)
>
>  I also want to dispel any myths surrounding fuse, because those help
>  nobody.

Sure.  I'll go on record saying that omfs_fuse was written over a weekend and
can not be considered a good example of anything.  I already had a
proto-libomfs that I had made for omfsck and mkomfs, and wanted to see how
easy it would be to wire that stuff up into a FUSE fs.  Pretty easily, it
turned out.

-- 
Bob Copeland %% www.bobcopeland.com
