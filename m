Return-Path: <linux-kernel-owner+w=401wt.eu-S1763429AbXF0WyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763429AbXF0WyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 18:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761638AbXF0WyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 18:54:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:53928 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761152AbXF0WyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 18:54:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=E7Bw5iluXPykeoU1SzQA9QV8qFujmUQ5WX2onq2KJQHvNK46X0X5sZ5hV6wffIo8/DOGznT8QAzv90ob74mD+WPTeB84EJXi5XW+D0/QzFkk961SvOdeKCeB9LbhbGH8brfe7cmZz0+UyIWZ0upgss0Trp+2qmCJ8eChFmLOM0c=
Message-ID: <20f65d530706271554j665ec1fne3030ce30597676d@mail.gmail.com>
Date: Thu, 28 Jun 2007 10:54:12 +1200
From: "Keith Chew" <keith.chew@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: [linux-usb-devel] usb_fill_bulk_urb() broken for USB1.1?
Cc: linux-usb-devel@lists.sourceforge.net, "Chuck Ebbert" <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200706270935.14657.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20f65d530706260720w797861fuc4e10bbbe2a489d2@mail.gmail.com>
	 <200706270827.50698.oliver@neukum.org>
	 <20f65d530706270030y5650e302yc5136adc0ac8dd46@mail.gmail.com>
	 <200706270935.14657.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver

> You are initialising an interrupt urb with an initializer for
> a bulk urb. The behavior is undefined. In older kernels
> by random chance a sensible interval was set.
>
> You need to use the correct initializer and the correct interval,
> which usually can be read from the device's descriptors.
>

Thank you very much for all your help. Will correct the code and
report back very soon.

Regards
Keith
