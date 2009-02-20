Return-Path: <linux-kernel-owner+w=401wt.eu-S1755796AbZBTT0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbZBTT0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 14:26:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbZBTTZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 14:25:49 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:43885 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbZBTTZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 14:25:48 -0500
Date: Fri, 20 Feb 2009 19:25:44 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: General question (scheduler) with SSDs?
Message-ID: <20090220192543.GA21644@silver.sucs.org>
References: <alpine.DEB.1.10.0902190837270.19552@p34.internal.lan> <20090220094356.GB26124@silver.sucs.org> <ac3eb2510902200316m387ecb45n86a2ea7c6196b01@mail.gmail.com> <20090220131209.GA21446@silver.sucs.org> <ac3eb2510902200523o619e64aas7bffac9aeca86814@mail.gmail.com> <20090220142705.GA429@silver.sucs.org> <ac3eb2510902200656l11275aber128848182553726d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510902200656l11275aber128848182553726d@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 03:56:06PM +0100, Kay Sievers wrote:
> Also the whitespace after "...PHISON *" does not need to be matched.
> If the match value does not end in whitespace itself, udev will match
> against the value with all trailing whitespace ignored.

Ah, I'm not matching against only whitespace:

$ cat /sys/block/*/device/model 
ASUS-PHISON OB S
ASUS-PHISON SSD 

(the first is the builtin faster SSD, the other is the slower removable
SSD).

-- 
Sitsofe | http://sucs.org/~sits/
