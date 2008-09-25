Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbYIYTkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbYIYTkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 15:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbYIYTkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 15:40:04 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:62756 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbYIYTkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 15:40:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Vj+lRiUDWwuCzzR3c6K5bVcqfp3vWJv6wcw+h+QpGjVOCsdUlIaOK4vyVhSXrYjW3v
         RyxuXY7q1Hm12Si4tpzUegUw72z9d0qXd8EORoGNdMVXg/FwV2nitXE7/K5dykfiHjtw
         FDk5F3XbdV/vUDRH2s1CWi/cfCQ/2K6DBl/rU=
Date: Thu, 25 Sep 2008 23:39:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tej <bewith.tej@gmail.com>
Cc: Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org
Subject: Re: Kernel PANIC with 2.6.27-rc6
Message-ID: <20080925193956.GF7259@localhost>
References: <f1c9d250809110841s5c3d08b9ha93f0ef1da58642a@mail.gmail.com> <48C94F65.3050405@windriver.com> <f1c9d250809250735i4b98201ft753d6ec2959097e6@mail.gmail.com> <20080925145635.GA7277@localhost> <20080925154724.GB7277@localhost> <f1c9d250809251134j6fac8bfu43f08cbf2b330f0a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1c9d250809251134j6fac8bfu43f08cbf2b330f0a@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Tej - Fri, Sep 26, 2008 at 12:04:30AM +0530]
...

Btw Tej, could you please apply this patch
and check if it help.

	http://lkml.org/lkml/2008/9/22/250

Aristeu Rozanski fixed one race window which take
place on unpredicted nmi's.

		- Cyrill -
