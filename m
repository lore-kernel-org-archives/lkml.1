Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbYC1N0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbYC1N0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 09:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbYC1N0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 09:26:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:10864 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbYC1N0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 09:26:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TMS79l3ntyS19s17UMFlGULiqJ0waiCYTzdZOhrwdCndao/oXqZ9FoH70hGbKcRRPg5PuKQ3Hnh3MSBrW0r9j58+4ldetPs63uICgj5tntzD5/nGIGwqPA+aQf94o5nnlxYwK2V5taDZppulcW3lZgy5ly9EtcBoR0bL/WDOQ/A=
Message-ID: <b6c5339f0803280626p221872b6t15f9b6fc9bc480f3@mail.gmail.com>
Date: Fri, 28 Mar 2008 09:26:19 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH 5/7] omfs: add bitmap routines
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <200803280451.11216.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206578760-9050-5-git-send-email-me@bobcopeland.com>
	 <200803280451.11216.arnd@arndb.de>
X-Google-Sender-Auth: e193ec81b06b9400
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 11:51 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 27 March 2008, Bob Copeland wrote:
>
>  > +static int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
>  > +
>  > +unsigned long omfs_count_free(struct super_block *sb)
>
>  I think it would be helpful to express this using hweight64.

Thanks for the review.

Yes, that would probably be cleaner.  FWIW minix and affs both have
this sort of code too.

-Bob
