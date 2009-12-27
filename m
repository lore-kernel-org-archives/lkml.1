Return-Path: <linux-kernel-owner+w=401wt.eu-S1751363AbZL0I22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbZL0I22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 03:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbZL0I21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 03:28:27 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:8083 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbZL0I20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 03:28:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=avdeQUbBvkztKg9cLNr7RQdREL/EFvJDbX+GO9NaooGYxT5DADuAkDKKWXhw323u5/
         5NuFB0IFZCFivyJFglECIOLmbfN1rvvWO/2a1IT84Kk+YXXoA1eT/WT303/EGNVlS3ql
         ynQTG1/xNCCIlj0ke9Y5FkEc2u3dQY4ezcBxI=
To: Roel Kluin <roel.kluin@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wl1251: timeout one too soon in wl1251_boot_run_firmware()
References: <4B3664AF.6090302@gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 27 Dec 2009 10:28:21 +0200
In-Reply-To: <4B3664AF.6090302@gmail.com> (Roel Kluin's message of "Sat\, 26 Dec 2009 20\:31\:59 +0100")
Message-ID: <87pr60yg62.fsf@purkki.valot.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin <roel.kluin@gmail.com> writes:

> `loop' reaches INIT_LOOP + 1 after the loop. so if ACX_INTR_INIT_COMPLETE
> occurs in the last iteration the write occurs but also the error out as if a
> timeout occurred. This is probably very unlikely to ever occur.

Thank you for fixing this.

> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: Kalle Valo <kalle.valo@nokia.com>

I think John can take this. As Roel mentioned, this is nothing
critical and, if needed, can wait until 2.6.34.

-- 
Kalle Valo
