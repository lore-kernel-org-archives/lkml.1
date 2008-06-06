Return-Path: <linux-kernel-owner+w=401wt.eu-S1764066AbYFFGJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764066AbYFFGJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 02:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYFFGI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 02:08:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47567 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbYFFGI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 02:08:58 -0400
Date: Thu, 5 Jun 2008 19:16:10 -0700
From: Greg KH <greg@kroah.com>
To: Markku Savela <msa@moth.iki.fi>
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: Bug/misfeature of "securityfs"
Message-ID: <20080606021610.GM3459@kroah.com>
References: <87iqx1pd24.fsf@burp.tkv.asdf.org> <Xine.LNX.4.64.0805271019550.17391@us.intercode.com.au> <20080527035241.GB20295@kroah.com> <200805270717.m4R7HriQ016260@burp.tkv.asdf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805270717.m4R7HriQ016260@burp.tkv.asdf.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 10:17:53AM +0300, Markku Savela wrote:
> I should not really reply from hip in the morning, ignore more
> previous message. The "file exists" definitely comes from the module
> init failing, because it finds the directory existing.
> 
> Here is some more detailed information and a test module
> (unfortunately, just pasted in this message):

<snip>

Hm, yeah, that doesn't look good at all :(

Any thoughts as to if you would have time to look into fixing this?
This isn't anything a normal user would ever hit, so I have a lot higher
priority things to handle at the moment, and it will be a while before I
could get to this.

thanks,

greg k-h
