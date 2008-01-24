Return-Path: <linux-kernel-owner+w=401wt.eu-S1759288AbYAXWvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288AbYAXWvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758231AbYAXWut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:50:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:22040 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758602AbYAXWus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:50:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=lTK0l3HVXy+MVHcn9layBWR77o6ypOBcGWSRHyaDkfdkevSVYdVi6n1T6Nd7fzaCCSToO6Y6J8MN+TcvAexPwyVxzbXD8Om8Vx+eb/6QA9NkbcncEka7F0iDe5ewZ45M/twvcPSuCixkomQd0lg2uvtaATZxkJjz3nlkIC+MC20=
Date: Fri, 25 Jan 2008 01:50:40 +0300
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch 07/26] Add INIT_ARRAY() to kernel.h (update 2)
Message-ID: <20080124225040.GC1975@martell.zuzino.mipt.ru>
References: <20080124202706.250598537@polymtl.ca> <20080124203335.082459062@polymtl.ca> <20080124125845.bf5767b8.randy.dunlap@oracle.com> <20080124210431.GA1647@Krystal> <tkrat.234abd01d9726428@s5r6.in-berlin.de> <20080124221054.GA5384@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080124221054.GA5384@Krystal>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 05:10:54PM -0500, Mathieu Desnoyers wrote:
> Array initializers in the body of a function causes unbalanced brackets which
> syntax highlighting editors such as vim have problems with. Fix this by creating
> the INIT_ARRAY() macro.
> 
> It is used to declare arguments passed as function parameters such as:
> text_poke(addr, INIT_ARRAY(unsigned char, 0xf0, len), len);

> +#define INIT_ARRAY(type, val, len) ((type[]) {[0 ... (len)-1] = (val)})

While we are at useless macro territory, let's name it MAKE_ARRAY because
it's exactly what it does.
