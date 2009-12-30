Return-Path: <linux-kernel-owner+w=401wt.eu-S1751773AbZL3CIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbZL3CIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 21:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbZL3CIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 21:08:36 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:46869 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZL3CIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 21:08:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qGBVur5vx3Fk29iJpDieGk9WNhiGXFIr8dzypLn8nZtaWx3Dfi7gR7wcjHpx6ycc8e
         oYwlpGjEVcK3QZ/yTFx2VdFq36jvKcbbtfxPb4G7SyDFgnf9q4/TsbrULktzSAEblsiM
         pEjKbnYX8kacOoUyxA9KvvNT+rTMXBKFyOsQk=
Date: Tue, 29 Dec 2009 18:08:30 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Vikram Dhillon <dhillonv10@gmail.com>
Cc: Stefani Seibold <stefani@seibold.net>, Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
Message-ID: <20091230020830.GA7049@core.coreip.homeip.net>
References: <20091227233816.GC2399@basil.fritz.box>
 <1261986136.808.2.camel@wall-e>
 <20091228145749.GD4994@basil.fritz.box>
 <1262016510.12656.25.camel@wall-e>
 <20091228172651.GE4994@basil.fritz.box>
 <1262030653.15368.37.camel@wall-e>
 <20091228204003.GH4994@basil.fritz.box>
 <1262076056.23095.21.camel@wall-e>
 <64D5262E-28CF-41E8-9425-F8C5DD0A2265@gmail.com>
 <ea6602020912291718n103694aft78ef15b65081a996@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea6602020912291718n103694aft78ef15b65081a996@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?

On Tue, Dec 29, 2009 at 08:18:50PM -0500, Vikram Dhillon wrote:
> IMHO you can process elements rather than bytes, which is a good
> improvement, but then again its my opinion, if others don't like it
> then we can always change it :D

Right, I was not arguing against having a record-oriented interface, I
was questioning the utility of processing several records at a time.
Kfifo users that I have seen so far were working in a record-at-a-time
mode.

Thanks.

-- 
Dmitry
