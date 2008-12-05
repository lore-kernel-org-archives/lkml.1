Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbYLEBJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbYLEBJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 20:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756478AbYLEBJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 20:09:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:11255 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955AbYLEBJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 20:09:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=aV1SuSE5f40iiA8DDyzwAFb9JysTU8NbfhmBJPBD/AarFCQZrMeVkfbyOpksL4j3b9
         xLMjuJ/EdaEWAoXOzgZyPmxG34mKDG3kcley1ZhqoVBdSIDVlh+NZe7DM/suCcpbseCw
         nOSzDiBWoyOZ5Ud3HMe89HFVsjLwOYXH9QGFA=
Message-ID: <483a38b80812041709i10abeae4n571355dd1d88b6c2@mail.gmail.com>
Date: Fri, 5 Dec 2008 10:09:29 +0900
From: "Kwangwoo Lee" <kwangwoo.lee@gmail.com>
To: "David Brownell" <david-b@pacbell.net>, felipe.balbi@nokia.com
Subject: Re: [PATCH] Add tsc2007 based touchscreen driver.
Cc: "ext Trilok Soni" <soni.trilok@gmail.com>, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org Mailing List" 
	<linux-omap@vger.kernel.org>
In-Reply-To: <200812040156.55943.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <483a38b80812020539v2323a784h7f202749687764db@mail.gmail.com>
	 <483a38b80812032107i761fb9bdkba9b2ce5e998ae6a@mail.gmail.com>
	 <20081204093715.GH10209@gandalf.research.nokia.com>
	 <200812040156.55943.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2008 at 6:56 PM, David Brownell <david-b@pacbell.net> wrote:
> On Thursday 04 December 2008, Felipe Balbi wrote:
>> i2c subsystem has smbus emulation. The special reason is just that it's
>> simpler for the driver writer ;-)
>
> I'd have said "more portable", actually.  I2C hosts can
> do pretty much everything an SMBus host can, but the
> converse is not true.
>
> And re i2c_check_functionality() ... yes, use it to make
> sure each I2C or SMBus call the driver makes is supported
> by the underlying controller.
>

Thank you Brownell and Balbi.
Your comments are very helpful for me. I'll fix some part of the
driver and send it again later.

-- 
Kwangwoo Lee <kwangwoo.lee@gmail.com>
