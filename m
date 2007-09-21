Return-Path: <linux-kernel-owner+w=401wt.eu-S1762446AbXIUTIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762446AbXIUTIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761004AbXIUTI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:08:26 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:17368 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760950AbXIUTIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:08:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=XTjAk3/dVQFc/k8xUJCqb8NhvSbBuJd+fo+ivZ1s1yfGQbFDIzFZY4jiIaDMUKNc8k/EcdvAW6N8m0kVQMqLyUlHRtJ7K2tsd4DmapJlZE3Oc6552U/0jhiRwt5IquO4GRlhhhiSwVBKmFsjehOwqPSAfUZjRhoKi+1ejlQuIwo=
Date: Fri, 21 Sep 2007 23:07:38 +0400
To: Tim Bird <tim.bird@am.sony.com>
Cc: Rob Landley <rob@landley.net>, linux-tiny@selenic.com,
       linux kernel <linux-kernel@vger.kernel.org>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       Michael Opdenacker <michael@free-electrons.com>
Subject: Re: printk proposal - (was Linux-tiny project revival)
Message-ID: <20070921190738.GB1857@martell.zuzino.mipt.ru>
References: <46F1645D.9050406@am.sony.com> <200709201538.43093.rob@landley.net> <20070920195844.GA1805@martell.zuzino.mipt.ru> <46F2D695.5070500@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F2D695.5070500@am.sony.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 01:22:45PM -0700, Tim Bird wrote:
> Alexey Dobriyan wrote:
> > Given that
> > a) there're plenty of printks without any KERN_* bloat,
> > b) there're printks that SHOULD NOT have KERN_* bloat,
> 
> Just to clarify, which bloat are you concerned about?
> I presume source code bloat (but maybe you mean
> message size bloat, or object code bloat)?

Users of ignore_loglevel still has "<[0-7]>" prefixes in kernel image,
yes. On source level, too -- as someone who never saw value in them,
KERN_* are just needless characters, making code harder to read.
