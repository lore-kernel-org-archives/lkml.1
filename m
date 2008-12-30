Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbYL3UIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbYL3UIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 15:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYL3UIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 15:08:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:56735 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbYL3UIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 15:08:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=wwVoEz+dYIIAPHeKiOFFl30L8YGzdXyeD774jEy4AGFiVGHx4h7d2pLHpUjMmpao+u
         eHMT9hXsTm/TF5psEA5V6ATVl2m35dxAyf188Wtd+p90NyOLDne7Xl2YaB2sHOniN3n2
         1lL/heNCWTndq9PGPpTiQ60Pq/AyBkXBs4ZZ4=
Message-ID: <84144f020812301208i34e5cc73hac25675f56e6aac0@mail.gmail.com>
Date: Tue, 30 Dec 2008 22:08:11 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [Patch][RFC] Supress Buffer I/O errors when SCSI REQ_QUIET flag set
Cc: jens.axboe@oracle.com, kmannth@us.ibm.com, linux-kernel@vger.kernel.org,
       sekharan@us.ibm.com, "Christoph Lameter" <cl@linux-foundation.org>,
       "Miklos Szeredi" <miklos@szeredi.hu>
In-Reply-To: <20081230114138.cd9e9763.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1227561983.6487.32.camel@keith-laptop>
	 <20081125091917.GU26308@kernel.dk>
	 <20081230113514.fe09d495.akpm@linux-foundation.org>
	 <20081230114138.cd9e9763.akpm@linux-foundation.org>
X-Google-Sender-Auth: 8d0cf30797c34d04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Tue, Dec 30, 2008 at 9:41 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> Seems that the rejects are due to other churn.  Where the heck did
> all the slab defrag code disappear to??
>
> I'll need to revert to yesterday's linux-next I think.  Pekka, has
> that stuff been dropped?

Yup, there hasn't been any activity after the last merge window so I'm
not expecting to be able to merge it for 2.6.29. As per linux-next
rules, I dropped the 2.6.30 material until the merge window closes.
The code is in topic/slub-defrag of slab.git, though.

                      Pekka
