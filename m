Return-Path: <linux-kernel-owner+w=401wt.eu-S965725AbXAYJQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965725AbXAYJQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 04:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965722AbXAYJQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 04:16:09 -0500
Received: from smtp-out.google.com ([216.239.33.17]:41360 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965725AbXAYJQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 04:16:07 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=YB1e3fWdwmhhgqpMyzIrDby7HD1Iv0dTOYZD/tI7GYAe4Fn8A1EyE/p2iK+Rssn4Q
	pqzTcUuzbh3+7kSe+Myyw==
Message-ID: <b040c32a0701250116l250338b6r37dc11df10b9d27b@mail.gmail.com>
Date: Thu, 25 Jan 2007 01:16:00 -0800
From: "Ken Chen" <kenchen@google.com>
To: "Dmitriy Monakhov" <dmonakhov@openvz.org>, akpm@osdl.org
Subject: Re: [RFC] mm: Move common segments checks to separate function
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1169715856.841146.284660@h3g2000cwc.googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7GVvX-5In-3@gated-at.bofh.it> <7H6KE-6iG-5@gated-at.bofh.it>
	 <1169715856.841146.284660@h3g2000cwc.googlegroups.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitriy Monakhov wrote on Jan 24, 11:00 pm
> > Move common segments checks from  __generic_file_aio_{read,write}_nolock()
> > to separate helper function generic_segment_checks().WOW my eyes ....
> I'm realy sorry but this patch is litle bit broken. :(
> I've forgot to check generic_segment_checks() return value.

why not remove the for loop all together?  like this:

http://groups.google.com/group/linux.kernel/browse_frm/thread/97550ddba48c8c8b/623ddad30b547702?lnk=st&q=&rnum=9#623ddad30b547702
