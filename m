Return-Path: <linux-kernel-owner+w=401wt.eu-S1759238AbZGCUKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238AbZGCUKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 16:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757505AbZGCUKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 16:10:32 -0400
Received: from mail-ew0-f215.google.com ([209.85.219.215]:45752 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbZGCUKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 16:10:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=seW+YRpggsEMKCq2wh738tqz9VYBY+S+4TtdsyTiZ54e5XW7bEoVyWCE1NdBVTK+jb
         vhPkhFDbe6U0eC1AVzlQUYP1XAuPLYZMGLeU2C0RHdYG4WrHbAJGkeZoAbAuBfBz62FG
         t0XKd9qJHzFmSJo58BmI5Nmc4s4Nd/Y9hAo7U=
MIME-Version: 1.0
In-Reply-To: <20090703193340.GA6060@hexapodia.org>
References: <1246410255-6839-1-git-send-email-adi@vmware.com>
	 <1246410255-6839-7-git-send-email-adi@vmware.com>
	 <ea8d860a0907031118o7ad0ad4nbe147b32bba57a29@mail.gmail.com>
	 <20090703193340.GA6060@hexapodia.org>
Date: Fri, 3 Jul 2009 22:10:30 +0200
X-Google-Sender-Auth: 8217ef6755f97535
Message-ID: <ea8d860a0907031310m5cdd21cy3e86e96c1217676d@mail.gmail.com>
Subject: Re: [tpmdd-devel] [PATCH 6/6] tpm_tis: add workarounds for iTPM
From: Marcin Obara <marcin_obara@users.sourceforge.net>
To: Andy Isaacson <adi@hexapodia.org>
Cc: Andy Isaacson <adi@vmware.com>, linux-kernel@vger.kernel.org,
       tpmdd-devel@lists.sourceforge.net, seiji.munetoh@gmail.com,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/3 Andy Isaacson <adi@hexapodia.org>:
> On Fri, Jul 03, 2009 at 08:18:18PM +0200, Marcin Obara wrote:
>> Intel iTPM on mobile platforms require this patch.
>> Intel iTPM on desktop platforms works well without this patch.
>
> Please do expand on this -- I don't have access to any iTPM desktop
> platforms to verify.  Can you provide information on what desktop
> platforms behave differently so that I can adjust the patch?
>
> If you could simply boot a kernel with my patch series on a desktop iTPM
> and provide the dmesg output, that would be great!

Intel iTPM with HID:  ICO0102 does not require this patch.
 (http://lkml.org/lkml/2008/6/28/143)

Currently, I don't have Q45 platform tested few months ago.

--
Marcin
