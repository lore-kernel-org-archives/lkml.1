Return-Path: <linux-kernel-owner+w=401wt.eu-S1752607AbZIXDSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbZIXDSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 23:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZIXDSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 23:18:42 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:53606 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbZIXDSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 23:18:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=H+C/01NRlRGWvvHlJIK0YhfK0I2gn8EKwnDJUWLVfJHb4X0JGMPrlgSRqpotoOFUSi
         OiTlRcpUIFaKQ+bx1HKAITbxh3ywiu+LMUB6RwKcfjWdMfMddDkVEDgSVx76w9Ffczop
         Ry2OEu44NhpSSf3vBCLgJIH9oCzFDwqZBZpdY=
MIME-Version: 1.0
In-Reply-To: <20090923191240.GA15198@dreamland.darkstar.lan>
References: <20090923191240.GA15198@dreamland.darkstar.lan>
Date: Wed, 23 Sep 2009 21:18:45 -0600
Message-ID: <51f3faa70909232018v7e621190m84deb648b08d2135@mail.gmail.com>
Subject: Re: [PATCH] asus_atk0110: add support for Asus P7P55D
From: Robert Hancock <hancockrwd@gmail.com>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 1:12 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:
> With P7P55D (and newer) boards Asus extended the output buffer (ASBF)
> making the driver unable to read the data from the sensors.
> Change the driver to use dynamic buffers (allocated by ACPI core); the
> return value is cached, so the number of memory allocations is very low.
>
> Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
> Tested-by: Robert Hancock <hancockrwd@gmail.com>

I just noticed a problem (either with this patch or some other issue
with the driver on this board): The readings don't seem to be
updating, I get the same values all the time. (Just now I started
compiling a kernel and coretemp reports temperatures in the 60 degree
plus range but atk0110-acpi still reports 35 degrees as it did
before..)
