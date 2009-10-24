Return-Path: <linux-kernel-owner+w=401wt.eu-S1751996AbZJXS4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbZJXS4G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 14:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZJXS4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 14:56:05 -0400
Received: from mail-qy0-f174.google.com ([209.85.221.174]:43361 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbZJXS4E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 14:56:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YmuMhdr5t0BqVee06v3SVZFBXI9KfddIzM2rZKcbyeKa+laPqur7S6M6whEINcf0mj
         X+A7LKL3xUtPf4ry+4Ly2VQddXyvJ0tQAJbh4qyrhyve09A+YcMyTwoQxWWLdgek5bis
         AnnE0icoHRWhjmryw5hMQm89dBUfJ+YzsOdSM=
MIME-Version: 1.0
In-Reply-To: <13bd74410910210406p18682e43nb28d330d80660f43@mail.gmail.com>
References: <13bd74410910210406p18682e43nb28d330d80660f43@mail.gmail.com>
Date: Sun, 25 Oct 2009 00:26:08 +0530
Message-ID: <5d5443650910241156k393d5093l4add89a3a7de980b@mail.gmail.com>
Subject: Re: [lm-sensors] TSC2003 application
From: Trilok Soni <soni.trilok@gmail.com>
To: kirthika varadarajan <kirthikaiitm@gmail.com>
Cc: linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krithika,

On Wed, Oct 21, 2009 at 4:36 PM, kirthika varadarajan
<kirthikaiitm@gmail.com> wrote:
> Hi,
>  I found the driver for TSC2003 in web for  Linux 2.6.12 .
>  I am using the driver.
>  How can i access the touch values in application.
> I2C communication in driver is ok.
>
> When ever i access from application I2C write fails.
>
> Suggest me if there is any sample application for Touch using I2C

Adding linux-input and linux-kernel ML and removing lm-sensors mailing list.

TSC2007 driver in latest kernel can be used for TSC2003 chip too. They
are similar chips. You can also find discussion on linux-input ML
archives. Just pass correct i2c board info from your board files if
using ARM like architecture based machine.


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
