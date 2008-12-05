Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbYLEMKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbYLEMKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 07:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYLEMK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 07:10:29 -0500
Received: from torres.zugschlus.de ([85.214.68.41]:50801 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbYLEMK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 07:10:29 -0500
Date: Fri, 5 Dec 2008 13:10:23 +0100
From: Marc Haber <mh+linux-kernel@zugschlus.de>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: pl2303 - pl2303_open - failed submitting interrupt urb, error -28
Message-ID: <20081205121023.GA21963@torres.zugschlus.de>
References: <20081202131821.GA25217@torres.zugschlus.de> <20081203014208.55dfeb8d.akpm@linux-foundation.org> <20081203154725.GB15968@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081203154725.GB15968@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 07:47:25AM -0800, Greg KH wrote:
> I would suggest using a USB 1.1 hub instead if you have to use this kind
> of hardware set up.

It is nearly impossible to buy that kind of hardware at the current
time.

>   I think the core is just not able to schedule so many interrupt urbs
>   with such a setup, running USB 1.1 devices behind a USB 2.0 hub like
>   this is a very difficult thing to do.
> 
> Sorry I don't have a better solution.

Is it possible to disable USB 2.0 for selected links?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 72739834
Nordisch by Nature |  How to make an American Quilt | Fax: *49 3221 2323190
