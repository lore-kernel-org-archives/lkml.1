Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbYIXMsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbYIXMsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 08:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbYIXMsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 08:48:42 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:53436 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbYIXMsl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 08:48:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=P8fZGDOn7n+T3ua7Th1huDSQrOkbhGoddh0SS5ykS+gcv+tD5O/XiW2ux0rrWMdxWX
         RoyN69VuKScqW3cwrXZxhSVpn0LqG6+bakvQ9/7Sxsa0D4O73vEJWkdK0umW5R7CLbmX
         wGkT13sUubmSCyn7BRp5uSscmhhCq2Z1ttiok=
Message-ID: <ed7dcf450809240548v1946068chf60dc42ff1f901d4@mail.gmail.com>
Date: Wed, 24 Sep 2008 14:48:39 +0200
From: "=?ISO-8859-1?Q?S=F8ren_Hauberg?=" <hauberg@gmail.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] usbtouchscreen, 2.6.25
Cc: "Oliver Neukum" <oliver@neukum.org>,
       "Ondrej Zary" <linux@rainbow-software.org>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <20080924103040.GA13392@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <ed7dcf450809230142l62bb00aapb92e6cb225f0cbba@mail.gmail.com>
	 <200809231051.14016.linux@rainbow-software.org>
	 <ed7dcf450809230236v762e0aa3v8748c76a64121f0c@mail.gmail.com>
	 <200809231613.41905.oliver@neukum.org>
	 <ed7dcf450809240004r1d3c7b3ds619cd7441ae0365e@mail.gmail.com>
	 <20080924103040.GA13392@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/24 Matthew Garrett <mjg59@srcf.ucam.org>:
> On Wed, Sep 24, 2008 at 09:04:55AM +0200, Søren Hauberg wrote:
>> Obviously that depends on how you define "better" :-) The problem I'm
>> facing is that with the X driver there is no way to change calibration
>> without restarting X several times, which isn't acceptable for the
>> application we're developing. Sure, I could fix the X driver to allow
>> run-time changes to the calibration parameters, but that's a very
>> large task.
>
> This is the sort of thing that input device properties were added for.
> If you're able to use 1.5 of the X server, it's not a huge body of work
> to add this functionality.

Well, 1.5 isn't an option for me. But this does remove the main
problem with handling calibration in X. So, I guess that means my
patch shouldn't be applied. I'll continue to use it in-house for a
while, but it won't be a long term solution.

Thanks,
Søren
