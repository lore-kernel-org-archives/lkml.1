Return-Path: <linux-kernel-owner+w=401wt.eu-S1760119AbYFFPL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760119AbYFFPL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757268AbYFFPLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:11:20 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:24453 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423AbYFFPLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:11:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f31neKP99gX9p0raToqB3TTJKDVzd4rlCKgJFzryVoyM2gITBEU4c6oQQ1EYFCeEbj
         mMR4z1hFmR8hjFXC+DhSHam5yGg/WClVB0Xs+Sm/OtML5O2EoaZNTpYxxz+yRwgVdI3/
         CKdgfGQk7OexjFIjumrf2JqfSWmsMWySlySzA=
Date: Fri, 6 Jun 2008 11:11:08 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Andrew Morton <akpm@osdl.org>, pavel@ucw.cz,
       Arjan van de Ven <arjan@infradead.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Yan Burman <burman.yan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       HWMON <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 2.6.25.4]  hwmon: HP Mobile Data Protection System 3D
	ACPI driver -- please review!
Message-ID: <20080606111051.ZZRA012@mailhub.coreip.homeip.net>
References: <1212235533.3815.5.camel@localhost> <4846EBF5.2030406@tremplin-utc.net> <20080606102636.ZZRA012@mailhub.coreip.homeip.net> <484950D2.9070809@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484950D2.9070809@tremplin-utc.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 04:59:30PM +0200, Eric Piel wrote:
> Dmitry Torokhov wrote:
>> Hi,
> Hello,
>>
>>
>> I would recommend converting the input piece to input_polled_device
>> instead of managing the polling thread by yourselves.
> Yes, you are right, I had forgotten about this one! That said, for now I'm 
> working on removing the polling and relying only the interrupts. So if it 
> works that shouldn't be needed :-)
>

Oh, great, this is even better.

-- 
Dmitry
