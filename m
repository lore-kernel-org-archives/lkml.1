Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbXIPTA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbXIPTA2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 15:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbXIPTAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 15:00:19 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:24702 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbXIPTAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 15:00:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=gekkyPtG1tG4SyNWSuceiXSqJwXHFjn7TSEVjFr4O6M1XEnA2Ftop99kmTTxL+vtgtQy6jltO8J7L3mEA0+ChzzOQPxxsaeSYvq3t6NO4dPGFjAvwBXCVNYC+ZRl+GOyCOvPSt2iWHGmOPWROooCbDlHhn78k32QkU9MjWOV1nk=
From: Matej Laitl <strohel@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v2] menuconfig: distinguish between selected-by-another options and comments
Date: Sun, 16 Sep 2007 21:00:08 +0200
User-Agent: KMail/1.9.7
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Roman Zippel <zippel@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200709152004.11930.strohel@gmail.com> <20070916184110.GB9630@uranus.ravnborg.org>
In-Reply-To: <20070916184110.GB9630@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200709162100.09698.strohel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 of September 2007 20:41:10 Sam Ravnborg wrote:
> On Sat, Sep 15, 2007 at 08:04:10PM +0200, Matej Laitl wrote:
> > menuconfig currently represents options implied by another option ('select'
> > directive in Kconfig) by prefixing them with '---'. Unfortunately the same
> > notation is used for comments.
> This is easy to fix - example below.
> 
> Now a comment looks like this
> 
>    *** This is a comment ***
> 
> Notice the three leading spaces which is where '---' was before.
> 
> 	Sam

Definitely this is the best solution for the comment ambiguity.

So my patch turned out to solve only these questions:
"What does the '--- Wireless extensions' mean? Included or excluded?"
"Why I cannot disable '<M> Option XXX'?"

Dunno if it is still worth merging. (but even if not, it at least made you
solve the comments problem) :)

Matěj.
