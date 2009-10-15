Return-Path: <linux-kernel-owner+w=401wt.eu-S935214AbZJORpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935214AbZJORpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 13:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935220AbZJORpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 13:45:54 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:61423 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202AbZJORpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 13:45:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=jx1I8ACHYqgCTMa+qtyPsd1yxfNMTTbrRg3FOIp9f73ut4eyn0B7dJE1fd82MkHLJ4
         cmKjmZjsEPx9SmQ+4XkLghi44QuxS7TZXR8wcfHqJQyLa7PYLXvcI1AWq6qkOLtZENPc
         ddtTcZNTjLbYCnNJfgBel7EB4Sm5Zx49/XX+I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Greg KH <gregkh@suse.de>
Subject: Re: removing existing working drivers via staging
Date: Thu, 15 Oct 2009 19:42:40 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31.1-56.fc12.x86_64; KDE/4.3.1; x86_64; ; )
Cc: david@lang.hm, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
References: <alpine.DEB.2.00.0910142213590.22169@asgard.lang.hm> <alpine.DEB.2.00.0910150936310.22169@asgard.lang.hm> <20091015164726.GA10125@suse.de>
In-Reply-To: <20091015164726.GA10125@suse.de>
MIME-Version: 1.0
Message-Id: <200910151942.40259.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 October 2009 18:47:26 Greg KH wrote:
> On Thu, Oct 15, 2009 at 09:39:51AM -0700, david@lang.hm wrote:
> > however, what I think I saw proposed was to move drivers that need to be 
> > 'cleaned up', to staging and then dropping them if they don't get cleaned.
> 
> What is "proposed" is the following:
> 
> 	- For drivers currently in the kernel tree, that the subsystem
> 	  maintainer, for whatever reason, feels is obsolete / broken /
> 	  needs major cleaning / wants to get rid of, can be submitted
> 	  to the staging maintainer to be moved to the drivers/staging/
> 	  directory.

This is insanity and opens a door for various forms of abuse.
