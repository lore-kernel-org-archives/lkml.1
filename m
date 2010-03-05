Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab0CEQqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:46:43 -0500
Received: from thunk.org ([69.25.196.29]:54889 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547Ab0CEQqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:46:40 -0500
Date: Fri, 5 Mar 2010 11:46:15 -0500
From: tytso@mit.edu
To: Daniel Stone <daniel@fooishbar.org>, David Miller <davem@davemloft.net>,
       skeggsb@gmail.com, airlied@linux.ie, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, mingo@elte.hu,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [git pull] drm request 3
Message-ID: <20100305164615.GC6000@thunk.org>
Mail-Followup-To: tytso@mit.edu, Daniel Stone <daniel@fooishbar.org>,
	David Miller <davem@davemloft.net>, skeggsb@gmail.com,
	airlied@linux.ie, linux-kernel@vger.kernel.org,
	jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, mingo@elte.hu,
	torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
References: <20100305151754.GB2505@tempa>
 <20100305.072612.186421758.davem@davemloft.net>
 <20100305154009.GC2505@tempa>
 <20100305.074835.159078083.davem@davemloft.net>
 <20100305160434.GE2505@tempa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100305160434.GE2505@tempa>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 06:04:34PM +0200, Daniel Stone wrote:
> 
> So you're saying that there's no way to develop any reasonable body of
> code for the Linux kernel without committing to keeping your ABI
> absolutely rock-solid stable for eternity, no exceptions, ever? Cool,
> that worked really well for Xlib.

No, that's not what people are saying.  What people are saying is,
"avoid flag days".  Deprecate things over a 6-12 month time period.
We have lots of really good interfaces for doing that.

You say you don't want to do that?  Then keep it to your self and
don't get it dropped into popular distributions like Fedora or Ubuntu.
You want a larger pool of testers?  Great!  The price you need to pay
for that is to be able to do some kind of of ABI versioning so that
you don't have "drop dead flag days".

If you don't want to be a good citizen, then prepared to have people
call you out for, well, not being a good OSS citizen.

     	     	  	    	    	 - Ted
