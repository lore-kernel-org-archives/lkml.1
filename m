Return-Path: <linux-kernel-owner+w=401wt.eu-S1762536AbXKPPIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762536AbXKPPIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 10:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755695AbXKPPIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 10:08:23 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:42658 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbXKPPIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 10:08:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=I9OYYHJJcySWxUHbzJNelf9QmjHINBkwf+XQp/l8dL3hKfvu+L96btFC8L9hcX+Af/m9+rppkwZyggbyVRZvI+BsQTkSjlpbKChPAx51+hw5zf8iMD0ArkaLQ9CbbF8nXdBgrQazWyjZ3jbyG5BcrdB8oGdTbrJxRGm+Ufl7t6o=
Message-ID: <3ae72650711160708m1855eb18q3a986998cfd87a3f@mail.gmail.com>
Date: Fri, 16 Nov 2007 16:08:21 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Martin Schwidefsky" <schwidefsky@de.ibm.com>
Subject: Re: [patch 1/6] sclp: sysfs interface for SCLP cpi
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       "Michael Ernst" <mernst@de.ibm.com>, "Greg KH" <greg@kroah.com>
In-Reply-To: <20071116143320.980985765@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071116142942.978412023@de.ibm.com>
	 <20071116143320.980985765@de.ibm.com>
X-Google-Sender-Auth: 361e4278c339a20a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 16, 2007 3:29 PM, Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> +
> +static decl_subsys(cpi, NULL, NULL);
> +

decl_subsys() and all other static kset cruft called "subsys" will be
gone with 2.6.25.
The patch series doing this is in -mm, and this patch will need
(trivial) adaption to the
new interfaces.

Thanks,
Kay
