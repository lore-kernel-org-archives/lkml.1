Return-Path: <linux-kernel-owner+w=401wt.eu-S1760169AbYG3WC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760169AbYG3WC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 18:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756284AbYG3WCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 18:02:07 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:38922 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162AbYG3WCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 18:02:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Nl/59cK0EIBGTTgQL8BdyAa3Ph/MRXFeW0OzkvOOrzgILcU42cFBiPv5uYOIaAf3X+
         B9SLXulcQH5G4MkSWKUGGlFBrmiHBkT703O65/7DninBqaQvJ4Cc0Q8MOlhF2Z8V8Fyy
         GqN10FVAdGDaPfHTgfS3uUcYkNtRAvLO3RVlg=
Message-ID: <3ae72650807301502h3e54e80yb405af7192048b89@mail.gmail.com>
Date: Thu, 31 Jul 2008 00:02:04 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Martin Schwidefsky" <schwidefsky@de.ibm.com>
Subject: Re: [patch 1/3] kmsg: Kernel message catalog macros.
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       lf_kernel_messages@lists.linux-foundation.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michael Holzheu" <holzheu@de.ibm.com>,
       "Gerrit Huizenga" <gh@us.ibm.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, "Jan Kara" <jack@suse.cz>,
       "Pavel Machek" <pavel@ucw.cz>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Joe Perches" <joe@perches.com>,
       "=?UTF-8?Q?Jochen_Vo=C3=9F?=" <jochen.voss@googlemail.com>,
       "Kunai Takashi" <kunai@linux-foundation.jp>,
       "Tim Bird" <tim.bird@am.sony.com>
In-Reply-To: <20080730171156.824640459@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080730165656.118280544@de.ibm.com>
	 <20080730171156.824640459@de.ibm.com>
X-Google-Sender-Auth: d63dd6e468b6bf92
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 18:56, Martin Schwidefsky
<schwidefsky@de.ibm.com> wrote:

> +#define kmsg_dev_alert(id, dev, format, arg...) \
> +       printk(__KMSG_CHECK(ALERT, id) KMSG_COMPONENT \
> +               ": %s: " format, (dev)->bus_id , ## arg)

Care to use dev_name(), bus_id will be removed soon.

Thanks,
Kay
