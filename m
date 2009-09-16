Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbZIPOrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbZIPOrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 10:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbZIPOrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 10:47:14 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:7284 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbZIPOrN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 10:47:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=YsDtpo6+fU3jYuLEj4QG8qX2lXIq2uNRmmKQbqRCGKM7H4Xagar5HrGXBADm0KzZIa
         GxWnKyIAZIiJ3QRxWBjsQG4njZcMRPDHvJitXik93W16E6tvBWwFl8wGg4rep2ZSmm9j
         8zlKkhPdMm99RM0/J31PsqS8hI35laODSkbxE=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0909161105580.8590@pc-004.diku.dk>
References: <Pine.LNX.4.64.0909161105580.8590@pc-004.diku.dk>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 16 Sep 2009 22:46:57 +0800
Message-ID: <f17812d70909160746k46b61baay1ace7ef06c1fa6b7@mail.gmail.com>
Subject: Re: [PATCH] arch/arm: adjust duplicate structure field initialization
To: Julia Lawall <julia@diku.dk>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 5:06 PM, Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
>
> Currently the irq_type field of the csb726_lan_config structure is
> initialized twice.  The value in the first case,
> SMSC911X_IRQ_POLARITY_ACTIVE_LOW, is normally stored in the irq_polarity
> field, so I have renamed the field in the first initialization to that.
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
>

Applied to 'fix'.
