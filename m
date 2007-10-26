Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbXJZIJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbXJZIJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 04:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbXJZIJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 04:09:19 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:42152 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbXJZIJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 04:09:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=hjiBsJ87JDioR2m9TKpjGwtHUiOHJCtQBf79JR+79/oTToYxoB8IWsEXwwTytXL1ypZWc/HY6MctDhBaEd/8sDO2F8n8TDP3iOTf31l+UQh67uA/bb2520X++gioK4Vl4R8J0Is66keQhdz2myB5rqcm8/eGjcNEnUpZm4mJR+8=
Message-ID: <84144f020710260109s56f9cdf2tcd7b7258fcb2bd8@mail.gmail.com>
Date: Fri, 26 Oct 2007 11:09:16 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Neil Brown" <neilb@suse.de>
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland
Cc: "Hugh Dickins" <hugh@veritas.com>, "Erez Zadok" <ezk@cs.sunysb.edu>,
       "Ryan Finnie" <ryan@finnie.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       cjwatson@ubuntu.com, linux-mm@kvack.org
In-Reply-To: <18209.19021.383347.160126@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0710142049000.13119@sbz-30.cs.Helsinki.FI>
	 <200710142232.l9EMW8kK029572@agora.fsl.cs.sunysb.edu>
	 <84144f020710150447o94b1babo8b6e6a647828465f@mail.gmail.com>
	 <Pine.LNX.4.64.0710222101420.23513@blonde.wat.veritas.com>
	 <84144f020710221348x297795c0qda61046ec69a7178@mail.gmail.com>
	 <Pine.LNX.4.64.0710251556300.1521@blonde.wat.veritas.com>
	 <18209.19021.383347.160126@notabene.brown>
X-Google-Sender-Auth: 8bf4716b5efbb9cf
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/26/07, Neil Brown <neilb@suse.de> wrote:
> It seems that the new requirement is that if the address_space
> chooses not to write out the page, it should now call SetPageActive().
> If that is the case, I think it should be explicit in the
> documentation - please?

Agreed.
