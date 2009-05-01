Return-Path: <linux-kernel-owner+w=401wt.eu-S1762782AbZEAO7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762782AbZEAO7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764237AbZEAOqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:46:49 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:33484 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764230AbZEAOqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:46:48 -0400
Date: Fri, 1 May 2009 16:48:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Howells <dhowells@redhat.com>
Cc: Tim Abbott <tabbott@MIT.EDU>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>
Subject: Re: [PATCH 0/6] section name cleanup for mn10300
Message-ID: <20090501144857.GA25398@uranus.ravnborg.org>
References: <1241135661-9147-1-git-send-email-tabbott@mit.edu> <2425.1241188519@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2425.1241188519@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 03:35:19PM +0100, David Howells wrote:
> Tim Abbott <tabbott@MIT.EDU> wrote:
> 
> > This patch series cleans up the section names on the mn10300
> > architecture.  It requires the architecture-independent macro
> > definitions from this patch series:
> 
> Interesting...  Whilst it compiles and links with no problems, this cleanup
> has the following detrimental effects:
> 
> None of these patches applied
> 
> 	   text    data     bss     dec     hex filename
> 	1879329   82980  321772 2284081  22da31 vmlinux
> 
> All of these patches applied:
> 
> 	   text    data     bss     dec     hex filename
> 	1879329   87076  321772 2288177  22ea31 vmlinux
> 
> Somewhere it eats an extra page.

This is likely due to moving around the sections and
we have got them in less perfect order.

I also thing 5/6 is wrong as it moves
init_task befoe _edata.

Could you try to back out them one by one
to see which one causes the extra memory waste.

	Sam
