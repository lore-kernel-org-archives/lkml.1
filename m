Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbYHEETA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbYHEETA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 00:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbYHEESa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 00:18:30 -0400
Received: from ozlabs.org ([203.10.76.45]:47447 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbYHEES3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 00:18:29 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
Date: Tue, 5 Aug 2008 14:18:05 +1000
User-Agent: KMail/1.9.9
Cc: linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20080728200500.GA14284@uranus.ravnborg.org>
In-Reply-To: <20080728200500.GA14284@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808051418.05324.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2008 06:05:00 Sam Ravnborg wrote:
> is is suggested to move the arch specific files under arch/
> and for the header files this is arch/$ARCH/include.

Well, it would have been nice to take the opportunity to separate user-visible 
header files and non-user-visible files.  We could have left the user-visible 
ones in place, for example: diffstat would then show when you were frobbing 
the userspace interface.

But I'm guessing noone wants even more marginal-value churn right now.
Rusty.
