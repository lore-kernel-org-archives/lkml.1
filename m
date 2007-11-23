Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbXKWCHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbXKWCHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 21:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755779AbXKWCHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 21:07:03 -0500
Received: from wx-out-0506.google.com ([66.249.82.233]:29294 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661AbXKWCHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 21:07:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=I1o4kPxZiCbpcG+H8DnVQfIuy0DxWWbCdZuc/F6nkWU8VvGSSYPiG4Cx5Ch8+iOj1TgQ7NRMzz3WABXYtx6VzHBEq1LXVq4/4X1CaBSJl6rJZcXuUg5ZGSebiPe5+Fi1a4+dyUsThg0RPgioRTeFcFHJetXQu0WW2qolMfrLJ1M=
Message-ID: <a8e1da0711221806r5bc80cfchfa65b96a37d6d20a@mail.gmail.com>
Date: Fri, 23 Nov 2007 10:06:58 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Cc: "Rusty Russell" <rusty@rustcorp.com.au>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, sam@ravnborg.org
In-Reply-To: <200711221919.11071.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071122343.446909000@suse.de>
	 <200711221456.22297.rusty@rustcorp.com.au>
	 <a8e1da0711220041v3d3c27d2pf7f326185666420d@mail.gmail.com>
	 <200711221919.11071.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 23, 2007 2:19 AM, Andi Kleen <ak@suse.de> wrote:
>
> > Andy, I like your idea.  IMHO, as Rusty said a simple EXPORT_SYMBOL_TO
> > is better.
>
> I don't think so. e.g. tcpcong would be very very messy this way.
>
> > And I wonder if it is possible to export to something like  the struct
> > device_driver? If it's possible then it will not limited to modules.
>
> Not sure I follow you. Can you expand?
>
I know little about module internal, so if I'm wrong please just don't
mind, please  point out or just ignore.

Kernel symbols could apply to kernel object model, doesn't it?
I just think that because the device_driver have a mod_name member
(for built-in module), so if something can be done as device driver is
registered.
