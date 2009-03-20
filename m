Return-Path: <linux-kernel-owner+w=401wt.eu-S1758893AbZCTCz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893AbZCTCz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 22:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbZCTCzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 22:55:14 -0400
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:62047 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbZCTCzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 22:55:14 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC Aufs2 #3 2/2] split 'xino' entry under sysfs 
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20090320024249.GA19989@kroah.com>
References: <1237439565-25039-1-git-send-email-hooanon05@yahoo.co.jp> <1237439565-25039-3-git-send-email-hooanon05@yahoo.co.jp> <20090320004539.GF18781@kroah.com> <3934.1237515949@jrobl> <20090320024249.GA19989@kroah.com>
Date: Fri, 20 Mar 2009 11:55:09 +0900
Message-ID: <4443.1237517709@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greg KH:
> Really?  Try leaving them out for now and see if anyone notices :)

Ok, then I will move them to debugfs.
Does the rule "one value per file" applied to debugfs too?


> Do you really need to print these paths?  And are they going to bigger
> than PATH_MAX?

Printing is necessary, and PATH_MAX will be sufficient.
I just wanted to forbid over-running when the path is incredibly longer.


J. R. Okajima
