Return-Path: <linux-kernel-owner+w=401wt.eu-S1752516AbYKWVMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbYKWVMz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 16:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbYKWVMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 16:12:47 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:30134 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbYKWVMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 16:12:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nyx4tLo2brg/j9wU7Qm5q4Zd/FQ0XjSjXnhMOKXvyFxXDCKei/qLqMTj1r7dUKqksf
         hR+CHZt0kuAa2G+FnlbaGxmU9g+ed47bVqihLymqELQn9cKGpWwipDUqymfQ/jD/L90l
         p2X404+YwWYp2pq6ZwosSno59pOeRJCkR+63w=
Message-ID: <c62985530811231312u51650cbcm2cb7b4f5c60d064@mail.gmail.com>
Date: Sun, 23 Nov 2008 22:12:44 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH] ftrace: Add a C/P state tracer to help power optimization
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org
In-Reply-To: <20081123125931.4afe16ca@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081123125931.4afe16ca@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

2008/11/23 Arjan van de Ven <arjan@infradead.org>:
> +static void power_trace_ctrl_update(struct trace_array *tr)
> +{
> +       if (tr->ctrl)
> +               start_power_trace();
> +       else
> +               stop_power_trace(tr);
> +}


The ctrl_update callback doesn't exist anymore...
