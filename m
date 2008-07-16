Return-Path: <linux-kernel-owner+w=401wt.eu-S1759189AbYGPWvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189AbYGPWvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 18:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYGPWvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 18:51:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:26698 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbYGPWvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 18:51:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=u/gZbEZ/oASphbpmafup6RAPUhZrThyWEtUWqwjFxnuej1KMiD92e9lt8hQXpQqlav
         QLw3yOAhhjQ1lxLJ2V4dlKBhs6i9P2roZzS7JEmZnScAAyBVs9NzA5mB87b1kMc4HaNy
         Usvfsad5E/0vzO5pmLkfDvuQFjX6wLl9OWA0E=
Message-ID: <86802c440807161551q1377c2e6i2d6444b8b61490ad@mail.gmail.com>
Date: Wed, 16 Jul 2008 15:51:23 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Cc: "Justin Mattock" <justinmattock@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080716140810.GA2861@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30807151252w7edcea19t8cec5ec5f958c7c0@mail.gmail.com>
	 <dd18b0c30807151726i622dabceve31828460085ee57@mail.gmail.com>
	 <20080716012427.GA27398@bromo.msbb.uc.edu>
	 <dd18b0c30807152005g3c58001br7182f7670d6247db@mail.gmail.com>
	 <20080716035830.GA27935@bromo.msbb.uc.edu>
	 <dd18b0c30807152230u39ef9c18v78b48d1c7b9ddd17@mail.gmail.com>
	 <86802c440807160044ge504cacl419b6cbcad5f0f9d@mail.gmail.com>
	 <dd18b0c30807160050r5b10908fiffc2a4b464abe5f3@mail.gmail.com>
	 <86802c440807160136m6af981b2u6a37cabb8e33a629@mail.gmail.com>
	 <20080716140810.GA2861@bromo.msbb.uc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 7:08 AM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
> Yunghai,
>   I had partial success with your proposed patch. The MacPro2
> identifier doesn't appear to be correct for a second generation
> MacBook Pro so I had to comment out the line...
>
>                     DMI_MATCH(DMI_PRODUCT_NAME, "MacPro2"),

you can use dmicode to get that string

YH
