Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbYKNLZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbYKNLZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 06:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbYKNLZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 06:25:27 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:46131 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbYKNLZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 06:25:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HgNdLSSU79CeXYZsvbi6ERRJjdRHVPEcZVe6oCHWFHkznTTxMEN3vnvlxqUwYZo/G5
         wq/XMr5GkDllUSAQO6B/LDGeEiguDsTGX0GH4ZmFhmDlUPfJGLeiN4l8ApZRRw7KsVk2
         eBxm7o+U7Jd0VTuQBha7DrTuxGX+huVjQYWrA=
Message-ID: <c62985530811140325p2e5faed6rc56036900e930d9d@mail.gmail.com>
Date: Fri, 14 Nov 2008 12:25:25 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] ftrace: Add debug_print trace to print data from kernel to userspace
Cc: rostedt@goodmis.org, mingo@elte.hu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1226659566-28168-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226659566-28168-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1226659566-28168-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot one thing:

2008/11/14 Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>:
> +static struct trace_array      *ctx_trace;


It's unnecessary, you are not using it :-)
