Return-Path: <linux-kernel-owner+w=401wt.eu-S933195AbYCACg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195AbYCACg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 21:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbYCACgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 21:36:47 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:56208 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbYCACgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 21:36:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=sUf87VWTVidZAzklHO82IZEfRkUqCWjEM22TT+vVAFFjdxL8n7vzmOBI3rwgNUOMWyz4sQwubj4yiI07TDUVhBOv0thovJbEugUKKGLMAKjvXnrDxFg5psrmEXbqXDsxCWAEasfX5nkokzHImyidwer66XI/w+S21b3eddxuhQM=
Message-ID: <47C8C052.2040509@gmail.com>
Date: Fri, 29 Feb 2008 20:32:50 -0600
From: Jon Schindler <jkschind@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, trivial@kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/9] /drivers/net/8390.c replaced init_module&cleanup_module
 with module_init&module_exit
References: <47C66311.7020000@watson.wustl.edu> <20080229172406.ec0f0cd9.akpm@linux-foundation.org>
In-Reply-To: <20080229172406.ec0f0cd9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sorry, ns8390_init_module should be ns8390_module_init.  I'll resend it in the next reply.
Andrew Morton wrote:
> On Thu, 28 Feb 2008 01:30:25 -0600
> Jon Schindler <jkschind@gmail.com> wrote:
> 
>> Replaced init_module and cleanup_module with static functions and module_init/module_exit.
> 
> I get
> 
> drivers/net/8390.c: In function '__inittest':
> drivers/net/8390.c:60: error: 'ns8390_init_module' undeclared (first use in this function)
> drivers/net/8390.c:60: error: (Each undeclared identifier is reported only once
> drivers/net/8390.c:60: error: for each function it appears in.)
> drivers/net/8390.c: At top level:
> drivers/net/8390.c:60: error: 'init_module' aliased to undefined symbol 'ns8390_init_module'
> 
> 

