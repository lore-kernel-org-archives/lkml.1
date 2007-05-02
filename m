Return-Path: <linux-kernel-owner+w=401wt.eu-S2992826AbXEBGvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992826AbXEBGvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992861AbXEBGvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:51:44 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:18996 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992826AbXEBGvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:51:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=p03AfxobUaI7o0COaegFnhyvl7tsezfJh7DqEwWRZN9FYsezWIUypSmcGw1qcnQO0EEOCfCW/3k4wXVU0tAgxXrck8jcaSMjMqNM/hdWPrP8o7Qkmeq8aMNS+I0XZktAe2t5VzwSaTG7wzIfNPPHxCdCSzX4P22DkECRhZ5AvOw=
Message-ID: <b3ece790705012351g5c0ff8a6g9f2f350ff86f3319@mail.gmail.com>
Date: Tue, 1 May 2007 23:51:41 -0700
From: "Tim Hockin" <thockin@hockin.org>
To: "=?UTF-8?Q?Rafa=C5=82_Bilski?=" <rafalbilski@interia.pl>
Subject: Re: Natsemi DP83815 driver spaming
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <463830E1.8080107@interia.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46365887.3010705@interia.pl> <20070501084639.GA528@sirena.org.uk>
	 <46371590.4090004@interia.pl> <20070501180830.GA31630@sirena.org.uk>
	 <46379A7E.3000109@interia.pl> <20070501212750.GC31630@sirena.org.uk>
	 <b3ece790705011543gdca3a9ei905d3499b6c18dc8@mail.gmail.com>
	 <46382798.2090709@interia.pl>
	 <b3ece790705012303x1e5a2d03xddf6c14aec5a99d8@mail.gmail.com>
	 <463830E1.8080107@interia.pl>
X-Google-Sender-Auth: 723a2e84b680b717
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Rafal Bilski <rafalbilski@interia.pl> wrote:

> 2.6.21.1 is first kernel which I'm using at this device. Earlier it was
> WindowsCE terminal. It is hardware fault. Commenting out the code is my
> way to avoid "wakeup" messages in log, but I don't want to change anything
> in vanilla kernel. I'm lucky that NIC is working at all.

I'm not sure what the right answer is.  The code was designed to do
the right thing, and yet in your case it's broken.  Does it need to be
a build option to work around broken hardware?  Yuck.
