Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbZIVOnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbZIVOnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbZIVOne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:43:34 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:53362 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbZIVOne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:43:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=cW/X3J688W3tXEHI8wW8K7Ppd3kKfXokmSjJKD55ILttbTZUGzOUUeRQfJsmsLhAeP
         TtzwVHJCsb3Ly35xfHZcDN1UqjlNalYHlFRTSmmzSJ9AcJwQjRsBK/OVqBxIvtAn4mP8
         OQjRGS/tlJFiC8b6ImkQfeGaHqAdb3zv/Uqgg=
MIME-Version: 1.0
In-Reply-To: <200909201509.14794.elendil@planet.nl>
References: <31cb94fa0909132225l6cb98739o59d105ef480d1cd2@mail.gmail.com>
	 <31cb94fa0909161712m3343812cw349b4a7233bda126@mail.gmail.com>
	 <31cb94fa0909172010v1af9b528vcad5fefbf75341e9@mail.gmail.com>
	 <200909201509.14794.elendil@planet.nl>
Date: Tue, 22 Sep 2009 22:43:36 +0800
Message-ID: <31cb94fa0909220743w6c512075ve69ec292b37a079a@mail.gmail.com>
Subject: Re: PATCH: ARCH in builddeb
From: Wei Chong Tan <weichong78@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: sam@ravnborg.org, max@stro.at, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frans,

> That still given me an arm instead of an armel package.
>
> I get the following from the deb-pkg target:
> dpkg-architecture: warning: Specified GNU system type arm-linux-gnu does
> not match gcc system type arm-linux-gnueabi.
> dpkg-deb: building package `linux-image-2.6.31' in `../linux-image-2.6.31_6481.gc7572df_arm.deb'.
>

dpkg-architecture seems to set a bunch of build-time environment
variable, could it be there one is not set by default for arm vs
armel?

Regards,
Wei Chong.
