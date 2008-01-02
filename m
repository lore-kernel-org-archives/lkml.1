Return-Path: <linux-kernel-owner+w=401wt.eu-S1758373AbYABNGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbYABNGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 08:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807AbYABNGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 08:06:31 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:60829 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbYABNG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 08:06:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=RlHNe84WRK63OQABg08TzkuuvJJvRGr4Bay1xLMAQwMC6hTTY4bcqJL8A8+/TPaQ/9XtziJHuto2A1wYyfDu3MtkjHcwzdgVrWowvxdB0ckgsPmAVOdI4W6dCx56N888jyLzbfVKQIORGfDbYvMWBQ79qQM907xSUYW8UYS01IM=
Date: Wed, 2 Jan 2008 14:12:19 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, Dave Young <hidave.darkstar@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
Message-ID: <20080102131219.GA3607@ff.dom.local>
References: <20080102070008.GA31343@suse.de> <20080102123938.GA3476@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102123938.GA3476@ff.dom.local>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 01:39:38PM +0100, Jarek Poplawski wrote:
> On 02-01-2008 08:00, Greg KH wrote:
> ...
> > If no one has noticed any issues in this area, [...]

BTW, if 'we' are sure there are no issues, and only lockdep is not
clever enough yet, why not do such a change partially, e.g. with
lockdep_on/off, at least to -mm, for testing?

Jarek P.
