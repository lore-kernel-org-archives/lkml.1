Return-Path: <linux-kernel-owner+w=401wt.eu-S1761561AbYEQAiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561AbYEQAiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 20:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760338AbYEQAiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 20:38:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:54714 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759205AbYEQAh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 20:37:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cT/xa/7UgFe/Xc1hZLEq2vTv4VDoJ16tpGLXuxgqyPUny7d+RoNhP1skp/yNmv51/AYCPxf7ni1R1j3ggPMo+lrVdaU/X1r4aB2pyxofhuN4vwT1OO2n+j5Upg7O4iKuSewAXBLSQbabIPQkleKnLpMRbhSrGYJNYN6nXZ9oJ3M=
Subject: Re: [RFC-PATCH] lib: add byteorder helpers for the aligned case
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Bryan Wu <cooloney@kernel.org>, Jie Zhang <jie.zhang@analog.com>,
       Oliver Neukum <oliver@neukum.org>, david-b@pacbell.net, greg@kroah.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.0805162022050.13416-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0805162022050.13416-100000@netrider.rowland.org>
Content-Type: text/plain
Date: Fri, 16 May 2008 17:37:56 -0700
Message-Id: <1210984676.5915.70.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-16 at 20:35 -0400, Alan Stern wrote:
> On Fri, 16 May 2008, Harvey Harrison wrote:
> 
> > +static inline void put_le16(u16 val, void *ptr)
> > +{
> > +	*(__le16 *)ptr = cpu_to_le16(val);
> > +}
> 
> Is this able to do the byte rearrangement at compile time if val is a 
> compile-time constant?  I imagine it would.
> 

Yes, the cpu_to_le/be functions to get optimized if they are passed a
compile time constant.


Harvey

