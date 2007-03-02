Return-Path: <linux-kernel-owner+w=401wt.eu-S2992654AbXCBRYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992654AbXCBRYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992663AbXCBRYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:24:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992654AbXCBRYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:24:51 -0500
Message-ID: <45E85DD2.8010905@redhat.com>
Date: Fri, 02 Mar 2007 11:24:34 -0600
From: Robert Peterson <rpeterso@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Paulo Marques <pmarques@grupopie.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21-rc1] Extend print_symbol capability
References: <45E744E2.1040000@redhat.com> <45E84C95.3060604@grupopie.com>
In-Reply-To: <45E84C95.3060604@grupopie.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paulo Marques wrote:
> I don't like this name much :(
>
> We already have kallsyms_lookup and kallsyms_lookup_name. The name of 
> this function should imply that it will print the formatted result 
> into the buffer, not just lookup a symbol.
>
> Maybe "__sprint_symbol", and change the interface to 
> "__sprint_symbol(char *buffer, unsigned long addr)"?
I'm not sure I like the leading __.  In the print_symbol case, I think 
the function
was given a leading __ so that code referencing print_symbol would use the
macro which formulates the call into __print_symbol.  I don't mind 
sprint_symbol
though.  Since Andrew Morton included the patch, I'll defer to his judgment.
>> +static inline void lookup_symbol(unsigned long addr, char *buffer)
>> +{
>> +       return NULL;
>> +}
> Returning NULL in a function returning "void" doesn't seem right :P
You're right.  This should just be a simple "return;".  My bad.  Good catch.
Since Andrew Morton has already included this patch, I'll let him
make this change if he sees fit.

Regards,

Bob Peterson
Red Hat Cluster Suite

