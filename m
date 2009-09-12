Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbZILDOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbZILDOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 23:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756806AbZILDOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 23:14:23 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:40454 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407AbZILDOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 23:14:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Ras15+DMxvkIBBpXoy4jn9HgqD4Su9qVK9D4NSkQuTH8U5o8sp5BDE06Y/ljmC8PM9
         FTQhPsP1cGOelVDUZMTVsfG9TAzbgIlBJx5o7BoWgZyXf61WO5dyho6s3ueV19n9hR9f
         JAy4gMfujlExVYx4Ipj+45WToTEiUqY17Shq8=
MIME-Version: 1.0
In-Reply-To: <20090911215958.GA30989@srcf.ucam.org>
References: <84fb38e30909110812r23ed0db0y80ae17178395694e@mail.gmail.com>
	 <20090911215958.GA30989@srcf.ucam.org>
Date: Fri, 11 Sep 2009 22:14:24 -0500
Message-ID: <84fb38e30909112014h7efd120dnef85794e3ba3fc39@mail.gmail.com>
Subject: Re: sony-laptop platform driver
From: tsuraan <tsuraan@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The interface used for that isn't sony-specific, so sony-laptop is the
> wrong place to put it. I've just submitted a patch to the nouveau
> developers.

In my case, I never want the nvidia card to be running.  Would I load
the nouveau driver for the sole purpose of shutting down the card?  I
don't want X to be using nouveau; it uses my intel card without any
problems, and with a small fraction of the power consumption.  Does
nouveau work without X?  I'm not familiar with how it is split between
user and kernel space.
