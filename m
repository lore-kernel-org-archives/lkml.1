Return-Path: <linux-kernel-owner+w=401wt.eu-S1761870AbXEKNdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761870AbXEKNdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 09:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761538AbXEKNdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 09:33:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:41585 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758583AbXEKNc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 09:32:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=EmRUIczJhOTkrCDvvBETI9XL2jO3UEgQ+wDddWf8uL9VtKKVvMLRWJCuvcudyB9FzfrBGnJeThnbS2H+g6svhkT5cMcuQv1yRJt0mZljYpQ6Oi306Sbrz3OYfHUs+AJAHbPj5hBy2RqJu8qUNlvBPOC4N/7B1YOywlVa/1ZuI54=
Message-ID: <528646bc0705110632p264f7f01g406802e3084fde0@mail.gmail.com>
Date: Fri, 11 May 2007 07:32:58 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH 1/2] Eliminate references to new_client in i2c documentation
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070511100139.7bf65825@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070510210409.11678.5134.stgit@trillian.secretlab.ca>
	 <20070511100139.7bf65825@hyperion.delvare>
X-Google-Sender-Auth: 8021f7d11615a99a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/11/07, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Grant,
>
> On Thu, 10 May 2007 15:04:16 -0600, Grant Likely wrote:
> > The use of 'new_client' in i2c device allocation has been refered to as
> > a 'disease'.  Replace all occurances of 'struct i2c_client *new_client'
> > in documentation examples with 'struct i2c_client *client'.
> >
> > Also remove unnecessary zero initializtion of .flags since kzalloc is used.
> >
> > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>
> Thanks for your contribution, however I made a similar documentation
> cleanup 3 weeks ago:
>   http://lists.lm-sensors.org/pipermail/i2c/2007-April/001075.html
> It's upstream already.

Heh, apparently I don't keep my edge bleeding enough

g.

-- 
Grant Likely, B.Sc. P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
