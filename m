Return-Path: <linux-kernel-owner+w=401wt.eu-S1759773AbYBVQ6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773AbYBVQ6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbYBVQ6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:58:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58423 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbYBVQ6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:58:20 -0500
Message-ID: <47BEFEC8.6020301@zytor.com>
Date: Fri, 22 Feb 2008 08:56:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Matt Domsch <Matt_Domsch@dell.com>, akpm@linux-foundation.org,
       Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add default mode CONFIG_EDD_OFF=n, override with edd={on,off}
References: <20080222162252.GB32088@auslistsprd01.us.dell.com> <20080222085307.e04af07f.randy.dunlap@oracle.com>
In-Reply-To: <20080222085307.e04af07f.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> 
> Where is "sk" valid (parsed) as a value for "edd="?
> I see "skip" or "skipmbr"....
> or is that just a typo, should be "skip[mbr]"?
> 

It used to only parse the first two letters; we now have a proper 
command-line parser.

	-hpa
