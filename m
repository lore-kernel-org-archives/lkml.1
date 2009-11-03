Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbZKCVRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbZKCVRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 16:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbZKCVRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 16:17:52 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:60001 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842AbZKCVRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 16:17:51 -0500
Message-ID: <4AF09E01.1060205@pobox.com>
Date: Tue, 03 Nov 2009 16:17:53 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 10/14] drivers/ata/libata: Move dereference after NULL
 test
References: <Pine.LNX.4.64.0910170841270.9213@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0910170841270.9213@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2009 02:41 AM, Julia Lawall wrote:
> From: Julia Lawall<julia@diku.dk>
>
> In each case, if the NULL test on qc is needed, then the derefernce
> should be after the NULL test.
>
> A simplified version of the semantic match that detects this problem is as
> follows (http://coccinelle.lip6.fr/):
>
> //<smpl>
> @match exists@
> expression x, E;
> identifier fld;
> @@
>
> * x->fld
>    ... when != \(x = E\|&x\)
> * x == NULL
> //</smpl>
>
> Signed-off-by: Julia Lawall<julia@diku.dk>

applied


