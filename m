Return-Path: <linux-kernel-owner+w=401wt.eu-S936145AbXGXJqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936145AbXGXJqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 05:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935765AbXGXJqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 05:46:16 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:62887 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933952AbXGXJqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 05:46:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=bc/2dte5fAY+8ZlsbuHM/AnRtBDQQM1NjCBCfjAEuslGKbGhsOEijzqDXxfwofKxTvNZ7XG8sIiYfp9BEybt/WmlSCkAYy+EBmByFkKOebZaqRPsVk6cDZTSO2binBHEnn1KC72rw38eeuj76wiigOsPuhxlTKTZNuFmH/Qwa5k=
Message-ID: <84144f020707240246v4ebe2c57r8cccf6f09e02a1e9@mail.gmail.com>
Date: Tue, 24 Jul 2007 12:46:12 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Akinobu Mita" <akinobu.mita@gmail.com>
Subject: Re: [patch 2/9] slab: fix memory leak in cpu hotplug error path
Cc: linux-kernel@vger.kernel.org, "Christoph Lameter" <clameter@sgi.com>,
       "Gautham R Shenoy" <ego@in.ibm.com>
In-Reply-To: <20070722153342.726607571@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070722153312.083951746@gmail.com>
	 <20070722153342.726607571@gmail.com>
X-Google-Sender-Auth: 7c9587f91a8fc4cf
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/22/07, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> This patch fixes memory leak in error path.
>
> In reality, we don't need to call cpuup_canceled(cpu) for now.
> But upcoming cpu hotplug error handling change needs this.

This and the previous patch look good to me.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
