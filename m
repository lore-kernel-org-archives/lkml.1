Return-Path: <linux-kernel-owner+w=401wt.eu-S1758807AbZBMANQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807AbZBMANQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 19:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZBMAM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 19:12:59 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:14088 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbZBMAM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 19:12:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bzuC87/BK5QJm4I+Sikwg/Vsg3bGEPEWk6D1BqgpA7I+qIhG5xpLyRxDX6TbIQu1LK
         thf+Rj0xWD4Zx0kU0DJfFXEfP9ercN+IiQ4iZXdNVYpFIVrGkv4VCYUSXMHCsh5AsDuk
         Z+PX/A8T+uprYU70uNJCkxfA4UZd/cG1Xt+G0=
MIME-Version: 1.0
In-Reply-To: <1234441811-9628-1-git-send-email-thierry.reding@avionic-design.de>
References: <20090212.204840.124087545.nemoto@toshiba-tops.co.jp>
	 <1234441811-9628-1-git-send-email-thierry.reding@avionic-design.de>
Date: Thu, 12 Feb 2009 17:12:57 -0700
X-Google-Sender-Auth: a2d32e1c17a787c9
Message-ID: <e9c3a7c20902121612q724d0931ifb70d559081f206d@mail.gmail.com>
Subject: Re: [PATCH v2] dmaengine: Fix oops on dmatest module unload.
From: Dan Williams <dan.j.williams@intel.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, haavard.skinnemoen@atmel.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 5:30 AM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> This patch fixes an oops that happens when the dmatest module is unloaded. The
> dma_release_channel() function is called on channels that have already been
> cleaned up (and therefore freed) with dmatest_cleanup_channel().
>
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Thanks, applied with Atsushi's ack.
