Return-Path: <linux-kernel-owner+w=401wt.eu-S1762899AbYCDJ3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762899AbYCDJ3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 04:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbYCDJ3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 04:29:33 -0500
Received: from gv-out-0910.google.com ([216.239.58.190]:41220 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068AbYCDJ3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 04:29:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=x6BKnEXB33P8sLlac5VjEZoPNI16PDAsjPeU9ng8YFV5tXF8JNrHi7GjSuMBraQ3/CtVOhzPC2FzLgJSP6aspPqQv93Xy785JMFfGFfNRvUwDtPG8ryAqx+7Wz9hNs26bpK91vhXv227QmQ1fMpAD55c5+Es2ueiOfR9cz5T3BQ=
Message-ID: <47CD1672.1030907@gmail.com>
Date: Tue, 04 Mar 2008 18:29:22 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tomof@acm.org,
       James.Bottomley@HansenPartnership.com, efault@gmx.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com, bzolnier@gmail.com
Subject: Re: [PATCH] block: fix residual byte count handling
References: <47CC7F3D.4010605@gmail.com> <20080304111056X.tomof@acm.org> <47CCB4D8.8090600@gmail.com> <20080304175302T.fujita.tomonori@lab.ntt.co.jp> <20080304085944.GG6704@kernel.dk>
In-Reply-To: <20080304085944.GG6704@kernel.dk>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

Jens Axboe wrote:
> I completely agree with you, ->data_len meaning true data length is way
> cleaner imho. Only the driver should care for the padded length, all
> other parts of the kernel only need to know what they actually got.

Oh well, I guess I'm the one with strange taste he
re.  My logic is that the only thing below the block layer is the driver
which requested size adjustment.  This means residual bytes calculation
is pushed to low level drivers which isn't anything major but still.
Anyways, I'll review FUJITA's modified patch.

Thanks.

-- 
tejun
