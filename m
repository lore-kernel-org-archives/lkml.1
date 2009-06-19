Return-Path: <linux-kernel-owner+w=401wt.eu-S1753081AbZFSBPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbZFSBPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 21:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbZFSBOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 21:14:53 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:45308 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbZFSBOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 21:14:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e7BdsdhKhDjVlEolGhYbsU7hXQd+hpc+sn1YYedK1Zm8/w/Z0BKYFOQO5Z+ayNh1el
         GHzGc34NGgO3uVNoej612DDxSAUw3Bogxfim4GDrs2vsUZNUwk9Am+w7mYmBAR4VtVev
         pVvq8EwIWob3FX2f846xehMJ0eG/HR/Sayeu4=
MIME-Version: 1.0
In-Reply-To: <1245366405-27426-1-git-send-email-jirislaby@gmail.com>
References: <1245366405-27426-1-git-send-email-jirislaby@gmail.com>
Date: Thu, 18 Jun 2009 21:14:54 -0400
Message-ID: <b6c5339f0906181814p7f052822je8903629445c8a30@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: fix beacon_int handling
From: Bob Copeland <bcopeland@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       ath5k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 7:06 PM, Jiri Slaby<jirislaby@gmail.com> wrote:
> 73ca5203366235f8a43e490767284ba8cfd8c479
> (ath5k: remove conf->beacon_int usage)
> removed bintval setting from ath5k_config. We need to init the
> interval earlier and don't touch it in add_interface anymore.
>
> Otherwise it will be set only once by upper layer through
> bss_info_changed but not on second and further hostap executions.

Shouldn't we just not destroy the value in add_interface?

I thought conf->beacon_int was deprecated.

-- 
Bob Copeland %% www.bobcopeland.com
