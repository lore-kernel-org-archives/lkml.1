Return-Path: <linux-kernel-owner+w=401wt.eu-S1030622AbXEBG2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030622AbXEBG2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030894AbXEBG2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:28:54 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:14705 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030622AbXEBG2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:28:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ZYBDUSO1egw2W8m1KncGker/jJZMoi4Qve2aMLsi8nL6q3IMDhq7kjywTObEyXINiLgZHBXPUtC1a8DA/cS8UZImJXEM6R5DVFHxqs89mZbGzafKBub7sQhIIZGy0ATRpMvRdIuq1Sr/xCiXnIScltJkxEtFswhHSBTRa9YUlYg=
Date: Wed, 2 May 2007 14:33:23 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] compiler: define __attribute_unused__
Message-ID: <20070502063323.GA6444@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: David Rientjes <rientjes@google.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com> <20070502051723.GB5843@martell.zuzino.mipt.ru> <Pine.LNX.4.64.0705012252020.21669@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705012252020.21669@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 10:53:52PM -0700, David Rientjes wrote:
>On Wed, 2 May 2007, Alexey Dobriyan wrote:
>
>> On Tue, May 01, 2007 at 09:28:18PM -0700, David Rientjes wrote:
>> > +#define __attribute_unused__		__attribute__((unused))
>> 
>> Suggest __unused which is shorter and looks compiler-neutral.
>> 
>
>So you would also suggest renaming __attribute_used__ and all 48 of its 
>uses to __used?

I suggest. ;-p 
'__attribute_unused__' is really long. I would prefer '__attribute__((unused))', since your macro doesn't let me type much less characters.

