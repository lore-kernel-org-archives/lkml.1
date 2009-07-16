Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbZGPJPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbZGPJPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 05:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbZGPJPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 05:15:46 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:41523 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbZGPJPp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 05:15:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hPRSixVmOq50qbba0F+VrebeyWZdSXdLQzRUeknILt5E0lzG5CgEnYgigc2iijNNaT
         zhW5lgxMkYa71cxRUW1bVCBujgSEDc2j1zEWOrO2kSuBrKbpNK6+Af9KOy4lAzcmS4wN
         PygCxksKvuHIZWiYQUQIqPKYP9t6/U3Oa4MxU=
MIME-Version: 1.0
In-Reply-To: <1247696049-15699-2-git-send-email-vapier@gentoo.org>
References: <1247696049-15699-1-git-send-email-vapier@gentoo.org>
	 <1247696049-15699-2-git-send-email-vapier@gentoo.org>
Date: Thu, 16 Jul 2009 10:15:43 +0100
Message-ID: <87a5b0800907160215x59ca8b4aj9a1d22b82d12e792@mail.gmail.com>
Subject: Re: [PATCH 2/3] connector: clean up grammar/style in documentation
From: Will Newton <will.newton@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 11:14 PM, Mike Frysinger<vapier@gentoo.org> wrote:
> The grammar in most of this file is slightly off, and some sections are
> hard to read due to lack of visual clues breaking up related material.
>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  Documentation/connector/connector.txt |  119 +++++++++++++++++----------------
>  1 files changed, 61 insertions(+), 58 deletions(-)
>
> diff --git a/Documentation/connector/connector.txt b/Documentation/connector/connector.txt
> index ad6e0ba..847f0d8 100644
> --- a/Documentation/connector/connector.txt
> +++ b/Documentation/connector/connector.txt
> @@ -5,10 +5,10 @@ Kernel Connector.
>  Kernel connector - new netlink based userspace <-> kernel space easy
>  to use communication module.
>
> -Connector driver adds possibility to connect various agents using
> -netlink based network.  One must register callback and
> -identifier. When driver receives special netlink message with
> -appropriate identifier, appropriate callback will be called.
> +The Connector driver adds makes it easy to connect various agents using a
> +netlink based network.  One must register a callback and an identifier.
> +When the driver receives a special netlink message with the appropriate
> +identifier, the appropriate callback will be called.

The first line of the second paragraph still needs work, "adds" should
probably be removed.
