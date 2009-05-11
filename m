Return-Path: <linux-kernel-owner+w=401wt.eu-S1760533AbZEKXXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760533AbZEKXXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 19:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759088AbZEKXX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:23:27 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:9278 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760133AbZEKXXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:23:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tcV6hMhRdgg/jhCUDVE6vKFZtt1ZrXDwFqbCR3OlASUktiWA1cjfNScUQkFGbkoKy6
         VLsOoRUnh6G/2jQ2dNFDOW/AqJAmhTpuR7p/oUEHINdi4A+6xT6hegwrnnuKSV+i4Z7D
         uinJ4twU+7iSbWeRN4Qfmu8rSi1zBQ5PxS7Zg=
MIME-Version: 1.0
In-Reply-To: <200905112319.8749@centrum.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <20090507120948.GA1531@ucw.cz> <200905080037.19722@centrum.cz>
	 <20090510053840.GG1363@ucw.cz> <200905112319.8749@centrum.cz>
Date: Mon, 11 May 2009 16:23:24 -0700
Message-ID: <faa09fad0905111623t24c3e421t8923c015788e2c56@mail.gmail.com>
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Alex Goebel <alex.goebel@gmail.com>
To: trekker.dk@centrum.cz
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/11/09, trekker.dk@centrum.cz <trekker.dk@centrum.cz> wrote:

> 1. AMD Athlon 1700+, VIA KT333 chipset based MB, nVidia GeForce 2
> 2. AMD X2 Athlon, AMD690V chipset based MB, nVidia 7600GT
> 3. (current) AMD X4 Phenom II,  AMD780G chipset and nVidia 9600GT
> (binary driver for video card every time)

The nvidia binary driver should generally both s2ram and s2disk with
unpatched kernels for quite some time now. You might have a problem in
userspace (/distribution) with some of the magic options not set
properly for your specific hardware.
Also, if the machine appears dead after resume, you might have to wait
up to ~2 minutes for the GPU to come alive due to a bug in the binary
driver (was only very recently fixed by nvidia).

Alex
