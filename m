Return-Path: <linux-kernel-owner+w=401wt.eu-S1751225AbZL0WOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225AbZL0WOp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 17:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbZL0WOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 17:14:44 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:52704 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZL0WOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 17:14:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZLq1l9lAl/PF981Y01llkG6hfNUOTWxUSaRnMjToiy6LUGoMOAPI3XgM9Jk8rGjRPl
         y7kp/DIEeemXyVnn1YvKmgcAUzq00vGBstbjor15pPS9rmgjIEvhUGb/Et/MZL6J+B4Y
         0AJvXuqxAJsR+UADCC1FiG5J8zjRNb2CCTSeg=
Date: Sun, 27 Dec 2009 14:14:38 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@osdl.org
Subject: Re: [PATCH] [6/6] kfifo: Document everywhere that size has to be
 power of two
Message-ID: <20091227221438.GA16353@core.coreip.homeip.net>
References: <200912271003.631128760@firstfloor.org>
 <20091227210316.B116EB17C3@basil.firstfloor.org>
 <1261950632.25298.33.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261950632.25298.33.camel@wall-e>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 27, 2009 at 10:50:32PM +0100, Stefani Seibold wrote:
> Am Sonntag, den 27.12.2009, 22:03 +0100 schrieb Andi Kleen:
> > On my first try using them I missed that the fifos need to 
> > be power of two, resulting in a runtime bug. Document that requirement
> > everywhere (and fix one grammar bug)
> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > 
> 
> Acked: Stefani Seibold <Stefani@Seibold.net>
> 

Now, does it really _have_ to be this way? For record-oriented
FIFO's it is customary to be 2*pow(n)*sizeof(rec) which is rarely
2*pow(m).

-- 
Dmitry
