Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbYGJMSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbYGJMSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 08:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbYGJMSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 08:18:14 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:22938 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbYGJMSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 08:18:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DkKsR09CZV1HC/YY6l7lUVqlOoDkmjYxNn404dU2OPS5v6BXSUpnfRbfHP93TaGaHy
         USAh1Uh/Pqr7BnkTE+EknxdsnlYVeL0g/okS0umIWNsJiD1k6IwpI6Pf3jc6GVQ3Cj9+
         lapxQlJopX4NvLy6YeUkQ0rMrCnE2xMY+WqRU=
Message-ID: <82faac5b0807100518s7e826026g1963b320724654d8@mail.gmail.com>
Date: Thu, 10 Jul 2008 22:18:10 +1000
From: "Darren Jenkins" <darrenrjenkins@gmail.com>
To: "Rustam Rakhimov" <rusyasoft@gmail.com>
Subject: Re: [PATCH][RE-SEND] drivers/isdn/i4l/isdn_common.c fix small resource leak
Cc: linux-kernel@vger.kernel.org, kkeil@suse.de
In-Reply-To: <7600b1330807070409s26146222g7e981dd30cfe3c7e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1215384758.11092.23.camel@localhost.localdomain>
	 <7600b1330807070409s26146222g7e981dd30cfe3c7e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

G'day Rustam,


On Mon, Jul 7, 2008 at 9:09 PM, Rustam Rakhimov <rusyasoft@gmail.com> wrote:
> sorry I don't understand what this function is doing ?
>

Looking at the code it looks like this function is writing data to the
card in a legacy (B ?) mode.


Darren J.
