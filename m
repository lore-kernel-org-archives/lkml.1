Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbYDPSc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbYDPSc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbYDPScQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:32:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:7660 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbYDPScP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:32:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=IRfBtXKmSnfNvtcrNhRICt9lZ68asTjWtPTQhDXs8T7M4j0t5rwyjfa5iIJUq07BlwO/nuj0/ZjTiU0ao9tHZ2vcJOTuOU+ZgwClNf9nT7sbHDeYNxx9GarTIkFsROC19AHmujBK6UaEyF8Kf9ZvTNj2Z+5QhsADM6uxrBkeAOY=
Date: Wed, 16 Apr 2008 20:31:42 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/7] omfs: add inode routines
Message-ID: <20080416183114.GA6264@joi>
References: <1208041121-26787-3-git-send-email-me@bobcopeland.com> <20080415183054.GA7176@joi> <20080415235659.GA7068@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415235659.GA7068@hash.localnet>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 07:56:59PM -0400, Bob Copeland wrote:
> > > +	return ret;
> > > +}
> > 
> > this code leaks omfs_sbi_info (sbi)
> 
> This one I'm not seeing.  FS core calls put_super if ret is nonzero so
> this should be ok?

Yep, you are right. Sorry for the noise.
I was mislead by other filesystems code.

Marcin
