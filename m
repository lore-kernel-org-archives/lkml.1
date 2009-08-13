Return-Path: <linux-kernel-owner+w=401wt.eu-S1752188AbZHMCSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbZHMCSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 22:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZHMCSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 22:18:54 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:58819 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbZHMCSy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 22:18:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XfXlheG9v3DcsZ0iyjW9qPqtKlsWSQrvS7n+bPnOqS4Wn21AWmSopc9Ef+dOfMfWqE
         iF3oW8xacZWdPVAdC3Ntn1GjKb/Q0tX+/giNcbinkFELduxcRR7r5RwfyjaKk40aZIbR
         Ya7cJPLR4c/MJu6Hz54iZPYDheusS/orWllNk=
MIME-Version: 1.0
In-Reply-To: <20090805171513.GA10443@kroah.com>
References: <20090805171513.GA10443@kroah.com>
Date: Thu, 13 Aug 2009 10:18:55 +0800
Message-ID: <d82e647a0908121918t7cc681ctd7973714def48d27@mail.gmail.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based 
	/dev
From: Ming Lei <tom.leiming@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/6 Greg KH <greg@kroah.com>:
> Here's the devtmpfs patch again.  For .32 it's a simple and clean patch.

I also prefer devtmpfs.

Base on devtmpfs, we can remove polling for being ready of some
asynchronous root device(usb storage, mmc, ....)
easily before mounting rootfs.

      http://marc.info/?l=linux-kernel&m=124955163908015&w=2
      http://marc.info/?l=linux-kernel&m=124955166508077&w=2

Thanks.

-- 
Lei Ming
