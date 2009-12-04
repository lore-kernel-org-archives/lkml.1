Return-Path: <linux-kernel-owner+w=401wt.eu-S932548AbZLDXNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548AbZLDXNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 18:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932515AbZLDXNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 18:13:53 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52752 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506AbZLDXNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 18:13:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LdkAjWr/evrrm7RPTGl4MAs7NNUMbGadY75GZqqsxz4pMN5aQeMgrNK3TJTLB9HI8x
         vbtmRr1fqja8nCszZvw7MbRZ9IaZZ88ZV0Vl3BkU/7OjiB4WLZfSTupyT+4g7VDev17y
         egDvJIDPjsugUfVFIgAvN77CrdnTxTJsCoCBI=
Date: Sat, 5 Dec 2009 02:13:58 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: andre.goddard@gmail.com
Cc: akmp@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: +
 vsprintf-reuse-almost-identical-simple_strtoulx-functions.patch added to
 -mm tree
Message-ID: <20091204231357.GA16465@x200>
References: <200912042232.nB4MW6Yp011297@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912042232.nB4MW6Yp011297@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 02:32:06PM -0800, akpm@linux-foundation.org wrote:
> The difference between simple_strtoul() and simple_strtoull() is just
> the size of the variable used to keep track of the sum of characters
> converted to numbers:
> 
> unsigned long simple_strtoul() {...}
> unsigned long long simple_strtoull(){...}

> Overflow condition is not checked on both functions,

and we should start doing it and remove strict_* idiocy.
