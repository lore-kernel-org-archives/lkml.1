Return-Path: <linux-kernel-owner+w=401wt.eu-S1762662AbYFEU6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762662AbYFEU6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 16:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYFEU6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 16:58:08 -0400
Received: from outbound-mail-149.bluehost.com ([67.222.38.39]:35587 "HELO
	outbound-mail-149.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751429AbYFEU6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 16:58:07 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 1/2] Eliminate double kfree
Date: Thu, 5 Jun 2008 13:58:02 -0700
User-Agent: KMail/1.9.9
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0805291504030.26229@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0805291504030.26229@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806051358.02217.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 29, 2008 6:04 am Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
>
> The destination of goto error also does a kfree(g_iommus), so it is not
> correct to do one here.

Thanks Julia, I'll put this in linux-next.

Jesse
