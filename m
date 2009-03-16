Return-Path: <linux-kernel-owner+w=401wt.eu-S1761993AbZCPV7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761993AbZCPV7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758705AbZCPV7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:59:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:48450 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746AbZCPV7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:59:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WiOMINqBotopzc79iFWW+8G98GT95a88VmYbZ6Qrk94ADMPOY+Jrl1wHsu9rvhSJGh
         3vWNmn+D1aLhRnFP7/zUazcBM7cWJJHjXw3Mnr3LhQiMb1GUulBh5zOKG9gi+0u7MUxo
         ZQHZDxfwIK3JMDPnuiOq9DygcXDT01WFPNPu4=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0903130837040.4653@axis700.grange>
References: <Pine.LNX.4.64.0903130837040.4653@axis700.grange>
Date: Mon, 16 Mar 2009 14:59:33 -0700
X-Google-Sender-Auth: 665c9ce65be99ab3
Message-ID: <e9c3a7c20903161459n8ad3c6qd705d146703b28a1@mail.gmail.com>
Subject: Re: [PATCH] ipu_idmac: code clean-up and robustness improvements
From: Dan Williams <dan.j.williams@intel.com>
To: Guennadi Liakhovetski <lg@denx.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 12:41 AM, Guennadi Liakhovetski <lg@denx.de> wrote:
> General code clean-up: remove superfluous semicolons, update comments.
> Robustness improvements: add DMA error handling to the ISR, move common code
> fragments to functions, fix scatter-gather element queuing in the ISR, survive
> channel freeing and re-allocation in a quick succession.
>
> Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
> ---
>
> Dan, I've been using this patch for a while, without any need for a
> change, so, it should be fine to go upstream.
>

Are you sure that we will never want to bisect in between these
several topics?  I would feel more comfortable with at least the fixes
separated from the code refactoring/pure additions.

Thanks,
Dan
