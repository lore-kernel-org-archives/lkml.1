Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbYJNOBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbYJNOBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 10:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbYJNOBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 10:01:38 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:8600 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbYJNOBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 10:01:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xzAwm8ZwPuvM0wg6kEJ1W2YF94Yg1ISYmYXVOqo+FsGmthgwnJAFfCVU+XOxoUUvNn
         NsGRLKeNtMW5EmL4acxYKyx/6GYTsyafV9ZFXLCy8q17QOS3vqMtjQwR4fCniAxgEzhK
         8jkY96jzd1m2hw92OL3TdiyRvyurhPkYQVz78=
Message-ID: <c62985530810140701s50f3a1an8da5383f8eefa29@mail.gmail.com>
Date: Tue, 14 Oct 2008 16:01:29 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>
Subject: Re : [PATCH 2/2] fastboot: fix row order in bootgraph.pl
Cc: "Ingo Molnar" <mingo@elte.hu>, "Arjan van de Ven" <arjan@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <48F49C53.1070103@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48F49C0F.7050705@tuffmail.co.uk> <48F49C53.1070103@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/14, Alan Jenkins <alan-jenkins@tuffmail.co.uk>:
> When bootgraph.pl parses a file, it gives one row for each initcall's
> pid.  But they are displayed in random (perl hash) order.  Let's
> sort the pids by the start time of their first initcall instead.

Thanks. That's a good idea!

I can't test it yet but I will give you a feedback as soon as I can.
