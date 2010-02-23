Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab0BWGnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 01:43:37 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35483 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab0BWGng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 01:43:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=YNswWN9aRoEF+ZOTI178rjpPxDMTGAOCDoQGaPo404HpBhS/96L586IYujvc+KSS68
         UAy3TQfj2hlL7O/dSiSkbAe3W9dLQDc3cmrwaBD/eFncut041TGF3go+iNt26szcuLDl
         +gboEOd+Gmdmd3BmXgCK9yvDtXUsH71i8ftm4=
MIME-Version: 1.0
In-Reply-To: <22dbbef21002222241h711402f1me6b60ac7502cccd4@mail.gmail.com>
References: <22dbbef21002222241h711402f1me6b60ac7502cccd4@mail.gmail.com>
Date: Tue, 23 Feb 2010 12:13:35 +0530
Message-ID: <22dbbef21002222243s7afb8e2cy1c783a29fe22ac55@mail.gmail.com>
Subject: QUERY: Inclusion of header files in kernel header files
From: viresh kumar <viresh.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have been through many kernel header files and have found that kernel header
files at many places don't include other header files which they have
dependency upon.

For example:
<linux/amba/bus.h> uses struct device and struct resource and it doesn't
include <linux/device.h> and <linux/resource.h> header files.

Now, whenever i try to include bus.h, i have to include device.h and resource.h.

Is this correct approach?

Again, if i include device.h and resource.h, they must be included before bus.h.
Now this will disturb the alphabetical ordering of including header files
sometimes. (not in this example)

Any idea behind this philosophy.

regards,
viresh kumar
ST Microelectronics
India.
